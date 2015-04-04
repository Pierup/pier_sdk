//
//  PierHttpExecutor.m
//  PierPaySDK
//
//  Created by zyma on 12/15/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PierHttpExecutor.h"
#import <UIKit/UIKit.h>
#import "PierJSONKit.h"
#import "PierConfig.h"
#import "NSString+PierCheck.h"

//超时时间
static NSTimeInterval PierHTTPTimeoutInterval = 30;

@interface NSData (PierImageData)
- (NSString *)getImageType;
- (BOOL)isJPG;
- (BOOL)isPNG;
- (BOOL)isGIF;
@end

@interface NSString (OAURLEncodingAdditions)
- (NSString*)encodedURLParameterString;
@end

typedef enum {
    PierTTPRequestStateReady,
    PierTTPRequestStateExecuting,
    PierHTTPRequestStateFinished
}PierHTTPRequestState;

static NSInteger PierHTTPTaskCount = 0;
static NSString *defaultUserAgent;


@interface PierHttpExecutor ()
@property (nonatomic, strong) NSMutableData *operationData;
@property (nonatomic, strong) NSFileHandle *operationFileHandle;
@property (nonatomic, strong) NSURLConnection *operationConnection;
@property (nonatomic, strong) NSString *operationSavePath;
@property (nonatomic, assign) CFRunLoopRef operationRunLoop;

@property (nonatomic, readwrite) PierHTTPRequestState state;

@property (nonatomic, copy) PierHttpSuccessBlock success;
@property (nonatomic, copy) PierHttpFailedBlock failed;
@property (nonatomic, strong) NSString *requestPath;//cancel server时候使用
@property (nonatomic, copy) void (^operationProgressBlock)(float progress);

#if TARGET_OS_IPHONE
@property (nonatomic, readwrite) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
#endif

#if !OS_OBJECT_USE_OBJC
@property (nonatomic, assign) dispatch_queue_t saveDataDispatchQueue;
@property (nonatomic, assign) dispatch_group_t saveDataDispatchGroup;
#else
@property (nonatomic, strong) dispatch_queue_t saveDataDispatchQueue;
@property (nonatomic, strong) dispatch_group_t saveDataDispatchGroup;
#endif

@property (nonatomic, strong) NSTimer *timeoutTimer; // see http://stackoverflow.com/questions/2736967
@property (nonatomic, readwrite) float expectedContentLength;
@property (nonatomic, readwrite) float receivedContentLength;

@property (nonatomic, assign) BOOL ignoreHTTPSCertification;

@end

@implementation PierHttpExecutor
@synthesize state = _state;

- (void)dealloc {
    [_operationConnection cancel];
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_saveDataDispatchGroup);
    dispatch_release(_saveDataDispatchQueue);
#endif
}

- (void)increasePIRHTTPTaskCount {
    PierHTTPTaskCount++;
    [self toggleNetworkActivityIndicator];
}

- (void)decreasePIRHTTPTaskCount {
    PierHTTPTaskCount = MAX(0, PierHTTPTaskCount-1);
    [self toggleNetworkActivityIndicator];
}

- (void)toggleNetworkActivityIndicator {
#if TARGET_OS_IPHONE && !__has_feature(attribute_availability_app_extension)
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(PierHTTPTaskCount > 0)];
    });
#endif
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.operationRequest setValue:value forHTTPHeaderField:field];
}

- (PierHttpExecutor*)initWithAddress:(NSString*)urlString method:(ePIRHttpMethod)method parameters:(NSDictionary*)parameters saveToPath:(NSString*)savePath progress:(void (^)(float))progressBlock success:(PierHttpSuccessBlock)success failed:(PierHttpFailedBlock)failed postAsJSON:(BOOL)postAsJSON {
    self = [super init];
    self.timeoutInterval = PierHTTPTimeoutInterval;
    self.cachePolicy = self.cachePolicy;
    self.userAgent = self.userAgent;
    
    self.success = success;
    self.failed  = failed;
    self.operationProgressBlock = progressBlock;
    self.operationSavePath = savePath;
    
    self.saveDataDispatchGroup = dispatch_group_create();
    self.saveDataDispatchQueue = dispatch_queue_create("com.pier.httpRequest", DISPATCH_QUEUE_SERIAL);
    
    
    NSString *urlStr = [urlString stringByAppendingString:@"?platform=2"];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    self.operationRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    if ([[url scheme] isEqualToString:@"https"]) {
        self.ignoreHTTPSCertification = YES;
    }else{
        self.ignoreHTTPSCertification = NO;
    }
    
    NSString *path = url.path;
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    [self setRequestPath:path];
    
    // pipeline all but POST and downloads
    
    if(method != PierHttpMethodPOST && !savePath)
        self.operationRequest.HTTPShouldUsePipelining = YES;
    
    if(method == PierHttpMethodGET){
        [self.operationRequest setHTTPMethod:@"GET"];
    }else if(method == PierHttpMethodPOST){
        [self.operationRequest setHTTPMethod:@"POST"];
    }else if(method == PierHttpMethodPUT){
        [self.operationRequest setHTTPMethod:@"PUT"];
    }
    
    self.state = PierTTPRequestStateReady;
    self.sendParametersAsJSON = postAsJSON;
    
    if(parameters){
        [self addParametersToRequest:parameters];
    }
    
    DLog(@"[Request]\n%@",parameters);
    
    return self;
}

- (void)addParametersToRequest:(NSDictionary*)paramsDict {
    NSString *method = self.operationRequest.HTTPMethod;
    
    if([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) {
        if(self.sendParametersAsJSON) {
            if([paramsDict isKindOfClass:[NSDictionary class]]) {
                [self.operationRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//                NSData *jsonData = [paramsDict JSONData];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDict options:0 error:nil];
                [self.operationRequest setHTTPBody:jsonData];
            }else{
                [NSException raise:NSInvalidArgumentException format:@"POST and PUT parameters must be provided as NSDictionary or NSArray when sendParametersAsJSON is set to YES."];
            }
        }else if([paramsDict isKindOfClass:[NSDictionary class]]) {
            __block BOOL hasData = NO;
            
            [paramsDict.allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if([obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[NSURL class]]){
                    hasData = YES;
                }else if(![obj isKindOfClass:[NSString class]] && ![obj isKindOfClass:[NSNumber class]]){
                    [NSException raise:NSInvalidArgumentException format:@"%@ requests only accept NSString and NSNumber parameters.", self.operationRequest.HTTPMethod];
                }
            }];
            
            if(!hasData) {
                const char *stringData = [[self parameterStringForDictionary:paramsDict] UTF8String];
                NSMutableData *postData = [NSMutableData dataWithBytes:stringData length:strlen(stringData)];
                [self.operationRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"]; //added by uzys
                [self.operationRequest setHTTPBody:postData];
            }else {
                NSString *boundary = @"PierBoundary";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
                [self.operationRequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
                self.timeoutInterval = PierHTTPTimeoutInterval*12;
                __block NSMutableData *postData = [NSMutableData data];
                __block int dataIdx = 0;
                // add string parameters
                [paramsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if(![obj isKindOfClass:[NSData class]] && ![obj isKindOfClass:[NSURL class]]) {
                        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                        [postData appendData:[[NSString stringWithFormat:@"%@", obj] dataUsingEncoding:NSUTF8StringEncoding]];
                        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    } else {
                        NSString *fileName = nil;
                        NSData *data = nil;
                        NSString *imageExtension = nil;
                        if ([obj isKindOfClass:[NSURL class]]) {
                            fileName = [obj lastPathComponent];
                            data = [NSData dataWithContentsOfURL:obj];
                        }else {
                            imageExtension = [obj getImageType];
                            fileName = [NSString stringWithFormat:@"pieruser%d%x", dataIdx, (int)[[NSDate date] timeIntervalSince1970]];
                            if (imageExtension != nil){
                                fileName = [fileName stringByAppendingPathExtension:imageExtension];
                            }
                            data = obj;
                        }
                        
                        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        if(imageExtension != nil) {
                            [postData appendData:[[NSString stringWithFormat:@"Content-Type: image/%@\r\n\r\n",imageExtension] dataUsingEncoding:NSUTF8StringEncoding]];
                        }else {
                            [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        }
                        
                        [postData appendData:data];
                        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        dataIdx++;
                    }
                }];
                
                [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [self.operationRequest setHTTPBody:postData];
            }
        }
        else
            [NSException raise:NSInvalidArgumentException format:@"POST and PUT parameters must be provided as NSDictionary when sendParametersAsJSON is set to NO."];
    }
    else if([paramsDict isKindOfClass:[NSDictionary class]]) {
        NSString *baseAddress = self.operationRequest.URL.absoluteString;
        if(paramsDict.count > 0)
            baseAddress = [baseAddress stringByAppendingFormat:@"?%@", [self parameterStringForDictionary:paramsDict]];
        [self.operationRequest setURL:[NSURL URLWithString:baseAddress]];
    }
    else
        [NSException raise:NSInvalidArgumentException format:@"GET and DELETE parameters must be provided as NSDictionary."];
}

- (NSString*)parameterStringForDictionary:(NSDictionary*)parameters {
    NSMutableArray *stringParameters = [NSMutableArray arrayWithCapacity:parameters.count];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([obj isKindOfClass:[NSString class]]) {
            [stringParameters addObject:[NSString stringWithFormat:@"%@=%@", key, [obj encodedURLParameterString]]];
        }
        else if([obj isKindOfClass:[NSNumber class]]) {
            [stringParameters addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
        else
            [NSException raise:NSInvalidArgumentException format:@"%@ requests only accept NSString, NSNumber and NSData parameters.", self.operationRequest.HTTPMethod];
    }];
    
    return [stringParameters componentsJoinedByString:@"&"];
}

- (void)setTimeoutTimer:(NSTimer *)newTimer {
    
    if(_timeoutTimer)
        [_timeoutTimer invalidate], _timeoutTimer = nil;
    
    if(newTimer)
        _timeoutTimer = newTimer;
}

#pragma mark - NSOperation methods

- (void)start {
    @autoreleasepool {
        if(self.isCancelled) {
            [self finish];
            return;
        }
#if TARGET_OS_IPHONE && !__has_feature(attribute_availability_app_extension)
        // all requests should complete and run completion block unless we explicitely cancel them.
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            if(self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
                self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            }
        }];
#endif
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self increasePIRHTTPTaskCount];
        });
        
        if(self.userAgent)
            [self.operationRequest setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
        else if(defaultUserAgent)
            [self.operationRequest setValue:defaultUserAgent forHTTPHeaderField:@"User-Agent"];
        
        [self willChangeValueForKey:@"isExecuting"];
        self.state = PierTTPRequestStateExecuting;
        [self didChangeValueForKey:@"isExecuting"];
        
        if(self.operationSavePath) {
            [[NSFileManager defaultManager] createFileAtPath:self.operationSavePath contents:nil attributes:nil];
            self.operationFileHandle = [NSFileHandle fileHandleForWritingAtPath:self.operationSavePath];
        } else {
            self.operationData = [[NSMutableData alloc] init];
            self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeoutInterval target:self selector:@selector(requestTimeout) userInfo:nil repeats:NO];
            [self.operationRequest setTimeoutInterval:self.timeoutInterval];
        }
        
        [self.operationRequest setCachePolicy:self.cachePolicy];
        self.operationConnection = [[NSURLConnection alloc] initWithRequest:self.operationRequest delegate:self startImmediately:NO];
        
        NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
        BOOL inBackgroundAndInOperationQueue = (currentQueue != nil && currentQueue != [NSOperationQueue mainQueue]);
        NSRunLoop *targetRunLoop = (inBackgroundAndInOperationQueue) ? [NSRunLoop currentRunLoop] : [NSRunLoop mainRunLoop];
        
        //修改NSURLConnection的运行模式,防止划定视图时候进度条不在更新
        if(self.operationSavePath){
            // schedule on main run loop so scrolling doesn't prevent UI updates of the progress block
            [self.operationConnection scheduleInRunLoop:targetRunLoop forMode:NSRunLoopCommonModes];
        }else{
            [self.operationConnection scheduleInRunLoop:targetRunLoop forMode:NSDefaultRunLoopMode];
        }
        
        [self.operationConnection start];
        
        DLog(@"[Header]\n%@",[self.operationRequest allHTTPHeaderFields]);
        DLog(@"[%@]\n%@", self.operationRequest.HTTPMethod, self.operationRequest.URL.absoluteString);
        
        // make NSRunLoop stick around until operation is finished
        if(inBackgroundAndInOperationQueue) {
            self.operationRunLoop = CFRunLoopGetCurrent();
            CFRunLoopRun();
        }
    }
}

// private method; not part of NSOperation
- (void)finish {
    [self.operationConnection cancel];
    self.operationConnection = nil;
    
    [self decreasePIRHTTPTaskCount];
    
#if TARGET_OS_IPHONE && !__has_feature(attribute_availability_app_extension)
    if(self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
#endif
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.state = PierHTTPRequestStateFinished;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)cancel {
    if(![self isExecuting])
        return;
    
    [super cancel];
    self.timeoutTimer = nil;
    [self finish];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return self.state == PierHTTPRequestStateFinished;
}

- (BOOL)isExecuting {
    return self.state == PierTTPRequestStateExecuting;
}

- (PierHTTPRequestState)state {
    @synchronized(self) {
        return _state;
    }
}

- (void)setState:(PierHTTPRequestState)newState {
    @synchronized(self) {
        [self willChangeValueForKey:@"state"];
        _state = newState;
        [self didChangeValueForKey:@"state"];
    }
}

#pragma mark -
#pragma mark Delegate Methods

- (void)requestTimeout {
    
    NSURL *failingURL = self.operationRequest.URL;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"The operation timed out.", NSLocalizedDescriptionKey,
                              failingURL, NSURLErrorFailingURLErrorKey,
                              failingURL.absoluteString, NSURLErrorFailingURLStringErrorKey, nil];
    
    NSError *timeoutError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:userInfo];
    [self connection:nil didFailWithError:timeoutError];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.expectedContentLength = response.expectedContentLength;
    self.receivedContentLength = 0;
    self.operationURLResponse = (NSHTTPURLResponse*)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    dispatch_group_async(self.saveDataDispatchGroup, self.saveDataDispatchQueue, ^{
        if(self.operationSavePath) {
            @try { //writeData: can throw exception when there's no disk space. Give an error, don't crash
                [self.operationFileHandle writeData:data];
            }
            @catch (NSException *exception) {
                [self.operationConnection cancel];
                NSError *writeError = [NSError errorWithDomain:@"PierHTTPWriteError" code:0 userInfo:exception.userInfo];
                [self callCompletionBlockWithResponse:nil error:writeError success:NO];
            }
        }
        else
            [self.operationData appendData:data];
    });
    
    if(self.operationProgressBlock) {
        //If its -1 that means the header does not have the content size value
        if(self.expectedContentLength != -1) {
            self.receivedContentLength += data.length;
            self.operationProgressBlock(self.receivedContentLength/self.expectedContentLength);
        } else {
            //we dont know the full size so always return -1 as the progress
            self.operationProgressBlock(-1);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    if(self.operationProgressBlock && [self.operationRequest.HTTPMethod isEqualToString:@"POST"]) {
        self.operationProgressBlock((float)totalBytesWritten/(float)totalBytesExpectedToWrite);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dispatch_group_notify(self.saveDataDispatchGroup, self.saveDataDispatchQueue, ^{
        
        id response = [NSData dataWithData:self.operationData];
        NSError *error = nil;
        
        if ([[self.operationURLResponse MIMEType] isEqualToString:@"application/json"]) {
            if(self.operationData && self.operationData.length > 0) {
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
                
                if(jsonObject)
                    response = jsonObject;
            }
        }else if ([[self.operationURLResponse MIMEType] isEqualToString:@"text/xml"]) {
//#ifdef DEBUG_ENV
//            NSString *text = [[NSString alloc] initWithData:self.operationData encoding:NSUTF8StringEncoding];
//            DLog(@"text:%@", text);
//#endif
//            NSDictionary *jsonObject = [XMLReader dictionaryForXMLData:self.operationData
//                                                               options:XMLReaderOptionsProcessNamespaces
//                                                                 error:&error];
//            if(jsonObject)
//                response = jsonObject;
            
            NSString *text = [[NSString alloc] initWithData:self.operationData encoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [NSDictionary dictionaryWithObject:text forKey:@"result"];
            if(jsonObject)
                response = jsonObject;
        }else if ([[self.operationURLResponse MIMEType] isEqualToString:@"text/html"]) {
            NSString *text = [[NSString alloc] initWithData:self.operationData encoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [NSDictionary dictionaryWithObject:text forKey:@"result"];
            if(jsonObject)
                response = jsonObject;
        }else if ([[self.operationURLResponse MIMEType] isEqualToString:@"text/plain"]){
            NSString *text = [[NSString alloc] initWithData:self.operationData encoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [NSDictionary dictionaryWithObject:text forKey:@"result"];
            if(jsonObject)
                response = jsonObject;
        }else{
            NSString *text = [[NSString alloc] initWithData:self.operationData encoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [NSDictionary dictionaryWithObject:text forKey:@"result"];
            if(jsonObject)
                response = jsonObject;
        }
        
        [self callCompletionBlockWithResponse:response error:error success:YES];
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self callCompletionBlockWithResponse:nil error:error success:NO];
}

#pragma mark - ---- NSURLConnection for https 服务器端单项HTTPS验证
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    if (self.ignoreHTTPSCertification) {
        return  [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    }else{
        return NO;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (self.ignoreHTTPSCertification) {
        if ([challenge previousFailureCount] == 0)
        {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        } else {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }
}

- (void)callCompletionBlockWithResponse:(id)response error:(NSError *)error success:(BOOL)isSuccess{
    self.timeoutTimer = nil;
    __block BOOL __isSuccess = isSuccess;
    
    if(self.operationRunLoop){//停止runloop
        CFRunLoopStop(self.operationRunLoop);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *serverError = error;
        
        if(!serverError) {
            if(self.operationURLResponse.statusCode == 500) {
                __isSuccess = NO;
            }
            else if(self.operationURLResponse.statusCode > 299) {
                __isSuccess = NO;
            }
        }
        if (!isSuccess) {
            if (self.failed && !self.isCancelled) {
                DLog(@"[Response] %@",response);
                NSString *message = [NSString getUnNilString:[response objectForKey:@"message"]];
                if ([NSString emptyOrNull:message]) {
                    message = @"Unknown error!";
                }
                serverError = [NSError errorWithDomain:message
                                                  code:[[NSString getUnNilString:[response objectForKey:@"code"]] integerValue] userInfo:response];
                
                DLog(@"[Error] %@",serverError);
                self.failed(self.operationURLResponse,serverError);
            }
        }else{
            if (self.success && !self.isCancelled) {
                DLog(@"[Response] %@",self.operationURLResponse);
                self.success(response,self.operationURLResponse);
            }
        }
        
        [self finish];
    });
}

@end

@implementation NSString (PierHTTPRequest)

- (NSString*)encodedURLParameterString {
    NSString *result = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                            (__bridge CFStringRef)self,
                                                                                            NULL,
                                                                                            CFSTR(":/=,!$&'()*+;[]@#?^%\"`<>{}\\|~ "),
                                                                                            kCFStringEncodingUTF8);
    return result;
}

@end

@implementation NSData (PierImageData)

- (BOOL)isJPG {
    if (self.length > 4) {
        unsigned char buffer[4];
        [self getBytes:&buffer length:4];
        
        return buffer[0]==0xff &&
        buffer[1]==0xd8 &&
        buffer[2]==0xff &&
        buffer[3]==0xe0;
    }
    
    return NO;
}

- (BOOL)isPNG {
    if (self.length > 4) {
        unsigned char buffer[4];
        [self getBytes:&buffer length:4];
        
        return buffer[0]==0x89 &&
        buffer[1]==0x50 &&
        buffer[2]==0x4e &&
        buffer[3]==0x47;
    }
    
    return NO;
}

- (BOOL)isGIF {
    if(self.length >3) {
        unsigned char buffer[4];
        [self getBytes:&buffer length:4];
        
        return buffer[0]==0x47 &&
        buffer[1]==0x49 &&
        buffer[2]==0x46; //Signature ASCII 'G','I','F'
    }
    return  NO;
}

- (NSString *)getImageType {
    NSString *ret;
    if([self isJPG]) {
        ret=@"jpg";
    }
    else if([self isGIF]) {
        ret=@"gif";
    }
    else if([self isPNG]) {
        ret=@"png";
    }
    else {
        ret=nil;
    }
    return ret;
}

@end