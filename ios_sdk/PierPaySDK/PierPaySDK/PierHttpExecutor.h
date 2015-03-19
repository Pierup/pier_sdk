//
//  PierHttpExecutor.h
//  PierPaySDK
//
//  Created by zyma on 12/15/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>
#import "PierHttpClient.h"

typedef enum {
    PierHttpMethodGET,
    PierHttpMethodPOST,
    PierHttpMethodPUT
}ePIRHttpMethod;

@interface PierHttpExecutor : NSOperation

@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, readwrite) BOOL sendParametersAsJSON;
@property (nonatomic, readwrite) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, readwrite) NSUInteger timeoutInterval;
@property (nonatomic, strong) NSMutableURLRequest *operationRequest;
@property (nonatomic, strong) NSHTTPURLResponse *operationURLResponse;

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

- (PierHttpExecutor*)initWithAddress:(NSString*)urlString
                             method:(ePIRHttpMethod)method
                         parameters:(NSObject*)parameters
                         saveToPath:(NSString*)savePath
                           progress:(void (^)(float))progressBlock
                            success:(PierHttpSuccessBlock)success
                             failed:(PierHttpFailedBlock)failed
                         postAsJSON:(BOOL)postAsJSON;
@end