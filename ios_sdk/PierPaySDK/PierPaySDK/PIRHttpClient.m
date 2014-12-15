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
- (PIRHttpExecutor*)GET:(NSString*)path
             parameters:(NSDictionary*)parameters
                success:(PIRHttpSuccessBlock)success
                 failed:(PIRHttpFailedBlock)failed{
    return [self queueRequest:path method:PIRHttpMethodGET parameters:parameters success:success failed:failed];
}

- (PIRHttpExecutor*)POST:(NSString*)path
              parameters:(NSDictionary*)parameters
                 success:(PIRHttpSuccessBlock)success
                  failed:(PIRHttpFailedBlock)failed{
    return [self queueRequest:path method:PIRHttpMethodPOST parameters:parameters success:success failed:failed];
}

- (PIRHttpExecutor*)queueRequest:(NSString*)path
                          method:(ePIRHttpMethod)method
                      parameters:(NSDictionary*)parameters
                         success:(PIRHttpSuccessBlock)success
                          failed:(PIRHttpFailedBlock)failed {
    return nil;
//    NSString *completeURLString = [NSString stringWithFormat:@"%@%@", self.basePath, path];
//    id mergedParameters;
//    
//    if((method == SVHTTPRequestMethodPOST || method == SVHTTPRequestMethodPUT) && self.sendParametersAsJSON && ![parameters isKindOfClass:[NSDictionary class]])
//        mergedParameters = parameters;
//    else {
//        mergedParameters = [NSMutableDictionary dictionary];
//        [mergedParameters addEntriesFromDictionary:parameters];
//        [mergedParameters addEntriesFromDictionary:self.baseParameters];
//    }
//    
//    SVHTTPRequest *requestOperation = [(id<SVHTTPRequestPrivateMethods>)[SVHTTPRequest alloc] initWithAddress:completeURLString
//                                                                                                       method:method
//                                                                                                   parameters:mergedParameters
//                                                                                                   saveToPath:savePath
//                                                                                                     progress:progressBlock
//                                                                                                   completion:completionBlock];
//    return [self queueRequest:requestOperation];
}


@end
