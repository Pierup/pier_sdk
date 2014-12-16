//
//  PIRHttpExecutor.h
//  PierPaySDK
//
//  Created by zyma on 12/15/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>
#import "PIRHttpClient.h"

typedef enum {
    PIRHttpMethodGET,
    PIRHttpMethodPOST,
    PIRHttpMethodPUT
}ePIRHttpMethod;

@interface PIRHttpExecutor : NSOperation

@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, readwrite) BOOL sendParametersAsJSON;
@property (nonatomic, readwrite) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, readwrite) NSUInteger timeoutInterval;
@property (nonatomic, strong) NSMutableURLRequest *operationRequest;

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
@end


@protocol PIRHTTPRequestProtocol <NSObject>

@property (nonatomic, strong) NSString *requestPath;
@property (nonatomic, strong) PIRHttpClient *client;

- (PIRHttpExecutor*)initWithAddress:(NSString*)urlString
                             method:(ePIRHttpMethod)method
                         parameters:(NSObject*)parameters
                         saveToPath:(NSString*)savePath
                           progress:(void (^)(float))progressBlock
                            success:(PIRHttpSuccessBlock)success
                             failed:(PIRHttpFailedBlock)failed
                         postAsJSON:(BOOL)postAsJSON;

@end