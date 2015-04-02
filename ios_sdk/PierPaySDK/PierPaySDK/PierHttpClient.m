//
//  PierHttpClient.m
//  PierPaySDK
//
//  Created by zyma on 12/15/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PierHttpClient.h"
#import "PierHttpExecutor.h"

#pragma mark - -------------------- Host --------------------
//NSString * const PierHttpClientUserHost      = @"http://192.168.1.254:8080";
//NSString * const PierHttpClientUserHostV2    = @"https://192.168.1.254:8443";

//NSString * const PierHttpClientUserHost      = @"http://pierup.ddns.net:8686";
//NSString * const PierHttpClientUserHostV2    = @"https://pierup.ddns.net:8443";

NSString * const PierHttpClientUserHost      = @"https://user-api.elasticbeanstalk.com";
NSString * const PierHttpClientUserHostV2    = @"https://user-api.elasticbeanstalk.com";



NSString * const PierHttpClientTypeEmptyHost = @"";
#pragma mark -

@interface PierHttpClient ()
@property (nonatomic, copy) NSString *basePath;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *HTTPHeaderFields;
@property (nonatomic, strong) NSDictionary *baseParameters;

@end

@implementation PierHttpClient

#pragma mark - ------------------ initial ------------------
+ (PierHttpClient *)sharedInstanceWithClientType:(ePIRHttpClientType)type{
    static NSMutableDictionary *__instanceMap = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{ __instanceMap = [[NSMutableDictionary alloc] init]; });
    PierHttpClient *__sharedInstance = [__instanceMap objectForKey:@(type)];
    if(!__sharedInstance) {
        @synchronized(self){
            if (!__sharedInstance) {
                __sharedInstance = [[self alloc] init];
                __sharedInstance.basePath = [__sharedInstance getHostByType:type];
                [__instanceMap setObject:__sharedInstance forKey:@(type)];
            }
        }
    }
    return __sharedInstance;
}

- (NSString *)getHostByType:(ePIRHttpClientType)type{
    switch (type) {
        case ePIRHttpClientType_User:
            return PierHttpClientUserHost;
            break;
        case ePIRHttpClientType_User_V2:
            return PierHttpClientUserHostV2;
            break;
        case ePIRHttpClientType_Empty:
            return PierHttpClientTypeEmptyHost;
            break;
        default:
            return PierHttpClientUserHost;
            break;
    }
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
- (PierHttpExecutor*)GET:(NSString*)path
             saveToPath:(NSString*)savePath
             parameters:(NSDictionary*)parameters
               progress:(void (^)(float))progressBlock
                success:(PierHttpSuccessBlock)success
                 failed:(PierHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PierHttpMethodGET
                   saveToPath:savePath
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:NO];
}

#pragma mark - HTTP POST
- (PierHttpExecutor*)POST:(NSString*)path
              parameters:(NSDictionary*)parameters
                progress:(void (^)(float))progressBlock
                 success:(PierHttpSuccessBlock)success
                  failed:(PierHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PierHttpMethodPOST
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:NO];
}

- (PierHttpExecutor*)JSONPOST:(NSString*)path
                  parameters:(NSDictionary*)parameters
                    progress:(void (^)(float))progressBlock
                     success:(PierHttpSuccessBlock)success
                      failed:(PierHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PierHttpMethodPOST
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:YES];
}

- (PierHttpExecutor*)UploadImage:(NSString*)path
                     parameters:(NSDictionary*)parameters
                       progress:(void (^)(float))progressBlock
                        success:(PierHttpSuccessBlock)success
                         failed:(PierHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PierHttpMethodPOST
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:NO];
}

- (PierHttpExecutor*)PUT:(NSString*)path
             parameters:(NSDictionary*)parameters
               progress:(void (^)(float))progressBlock
                success:(PierHttpSuccessBlock)success
                 failed:(PierHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PierHttpMethodPUT
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:NO];
}

- (PierHttpExecutor*)JSONPUT:(NSString*)path
                 parameters:(NSDictionary*)parameters
                   progress:(void (^)(float))progressBlock
                    success:(PierHttpSuccessBlock)success
                     failed:(PierHttpFailedBlock)failed{
    return [self queueRequest:path
                       method:PierHttpMethodPUT
                   saveToPath:nil
                   parameters:parameters
                     progress:progressBlock
                      success:success
                       failed:failed
                   postAsJSON:YES];
}

#pragma mark - HTTP Request
- (PierHttpExecutor*)queueRequest:(NSString*)path
                          method:(ePIRHttpMethod)method
                      saveToPath:(NSString*)savePath
                      parameters:(NSDictionary*)parameters
                        progress:(void (^)(float))progressBlock
                         success:(PierHttpSuccessBlock)success
                          failed:(PierHttpFailedBlock)failed
                      postAsJSON:(BOOL)postAsJSON{
    NSString *completeURLString = [NSString stringWithFormat:@"%@%@", self.basePath, path];
    id mergedParameters;
    
    if((method == PierHttpMethodPOST ) && ![parameters isKindOfClass:[NSDictionary class]])
        mergedParameters = parameters;
    else {
        mergedParameters = [NSMutableDictionary dictionary];
        [mergedParameters addEntriesFromDictionary:parameters];
        [mergedParameters addEntriesFromDictionary:self.baseParameters];
    }
    PierHttpExecutor *requestOperation = [[PierHttpExecutor alloc] initWithAddress:completeURLString method:method parameters:mergedParameters saveToPath:savePath progress:progressBlock success:success failed:failed postAsJSON:postAsJSON];
    return [self queueRequest:requestOperation];
}

#pragma mark - ------------------ HTTP Operqtions ------------------
- (PierHttpExecutor *)queueRequest:(PierHttpExecutor *)requestOperation {
    
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
