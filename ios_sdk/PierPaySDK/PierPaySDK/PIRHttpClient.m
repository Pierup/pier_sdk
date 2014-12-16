//
//  PIRHttpClient.m
//  PierPaySDK
//
//  Created by zyma on 12/15/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PIRHttpClient.h"
#import "PIRHttpExecutor.h"

@interface PIRHttpClient ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *HTTPHeaderFields;
@end

@implementation PIRHttpClient

#pragma mark - ------------------ initial ------------------
+ (PIRHttpClient *)sharedInstanceWithClientType:(ePIRHttpClientType)type{
    static NSMutableDictionary *__instanceMap = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ __instanceMap = [[NSMutableDictionary alloc] init]; });
    PIRHttpClient *__sharedInstance = [__instanceMap objectForKey:@(type)];
    if(!__sharedInstance) {
        @synchronized(self){
            if (!__sharedInstance) {
                __sharedInstance = [[self alloc] init];
                [__instanceMap setObject:__sharedInstance forKey:@(type)];
            }
        }
    }
    return __sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.basePath = @"";
    }
    
    return self;
}

#pragma mark - ------------------ HTTP Request ------------------
#pragma mark - setting
- (NSMutableDictionary *)HTTPHeaderFields {
    if(_HTTPHeaderFields == nil)
        _HTTPHeaderFields = [NSMutableDictionary new];
    
    return _HTTPHeaderFields;
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.HTTPHeaderFields setValue:value forKey:field];
}

#pragma mark - HTTP GTE
- (PIRHttpExecutor*)GET:(NSString*)path
             saveToPath:(NSString*)savePath
             parameters:(NSDictionary*)parameters
               progress:(void (^)(float))progressBlock
                success:(PIRHttpSuccessBlock)success
                 failed:(PIRHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PIRHttpMethodGET
                   saveToPath:savePath
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:NO];
}

#pragma mark - HTTP POST
- (PIRHttpExecutor*)POST:(NSString*)path
              parameters:(NSDictionary*)parameters
                progress:(void (^)(float))progressBlock
                 success:(PIRHttpSuccessBlock)success
                  failed:(PIRHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PIRHttpMethodPOST
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:NO];
}

- (PIRHttpExecutor*)JSONPOST:(NSString*)path
                  parameters:(NSDictionary*)parameters
                    progress:(void (^)(float))progressBlock
                     success:(PIRHttpSuccessBlock)success
                      failed:(PIRHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PIRHttpMethodPOST
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:YES];
}

- (PIRHttpExecutor*)PUT:(NSString*)path
             parameters:(NSDictionary*)parameters
               progress:(void (^)(float))progressBlock
                success:(PIRHttpSuccessBlock)success
                 failed:(PIRHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PIRHttpMethodPUT
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:NO];
}

- (PIRHttpExecutor*)JSONPUT:(NSString*)path
                 parameters:(NSDictionary*)parameters
                   progress:(void (^)(float))progressBlock
                    success:(PIRHttpSuccessBlock)success
                     failed:(PIRHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PIRHttpMethodPUT
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:YES];
}

#pragma mark - HTTP Request
- (PIRHttpExecutor*)queueRequest:(NSString*)path
                          method:(ePIRHttpMethod)method
                      saveToPath:(NSString*)savePath
                      parameters:(NSDictionary*)parameters
                        progress:(void (^)(float))progressBlock
                         success:(PIRHttpSuccessBlock)success
                          failed:(PIRHttpFailedBlock)failed
                      postAsJSON:(BOOL)postAsJSON{
    NSString *completeURLString = [NSString stringWithFormat:@"%@%@", self.basePath, path];
    id mergedParameters;
    
    if((method == PIRHttpMethodPOST ) && ![parameters isKindOfClass:[NSDictionary class]])
        mergedParameters = parameters;
    else {
        mergedParameters = [NSMutableDictionary dictionary];
        [mergedParameters addEntriesFromDictionary:parameters];
        [mergedParameters addEntriesFromDictionary:self.baseParameters];
    }
    PIRHttpExecutor *requestOperation = [[PIRHttpExecutor alloc] initWithAddress:completeURLString method:method parameters:mergedParameters saveToPath:savePath progress:progressBlock success:success failed:failed postAsJSON:postAsJSON];
    return [self queueRequest:requestOperation];
}

#pragma mark - ------------------ HTTP Operqtions ------------------
- (PIRHttpExecutor *)queueRequest:(PIRHttpExecutor *)requestOperation {
    requestOperation.cachePolicy = self.cachePolicy;
    requestOperation.userAgent = self.userAgent;
    requestOperation.timeoutInterval = self.timeoutInterval;
    
    [self.HTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *field, NSString *value, BOOL *stop) {
        [requestOperation setValue:value forHTTPHeaderField:field];
    }];
    
    [self.operationQueue addOperation:requestOperation];
    
    return requestOperation;
}

#pragma mark - Operation Cancelling
- (void)cancelRequestsWithPath:(NSString *)path {
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(id request, NSUInteger idx, BOOL *stop) {
        NSString *requestPath = [request valueForKey:@"requestPath"];
        if([requestPath isEqualToString:path])
            [request cancel];
    }];
}

#pragma mark - cancel all
- (void)cancelAllRequests {
    [self.operationQueue cancelAllOperations];
}
@end
