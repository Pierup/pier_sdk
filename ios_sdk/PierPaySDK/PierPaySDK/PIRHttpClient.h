//
//  PIRHttpClient.h
//  PierPaySDK
//
//  Created by zyma on 12/15/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PIRHttpExecutor;

/** success block */
typedef void (^PIRHttpSuccessBlock)(id response, NSHTTPURLResponse *urlResponse);
/** failed block */
typedef void (^PIRHttpFailedBlock)(NSHTTPURLResponse *urlResponse, NSError *error);

typedef enum {
    ePIRHttpClientType_User
}ePIRHttpClientType;

@interface PIRHttpClient : NSObject

@property (nonatomic, strong) NSString *basePath;
@property (nonatomic, strong) NSString *userAgent;

@property (nonatomic, readwrite) BOOL sendParametersAsJSON;
@property (nonatomic, strong) NSDictionary *baseParameters;
@property (nonatomic, readwrite) NSUInteger timeoutInterval;
@property (nonatomic, readwrite) NSURLRequestCachePolicy cachePolicy;

+ (PIRHttpClient *)sharedInstanceWithClientType:(ePIRHttpClientType)type;

- (PIRHttpExecutor*)GET:(NSString*)path
             saveToPath:(NSString*)savePath
             parameters:(NSDictionary*)parameters
               progress:(void (^)(float))progressBlock
                success:(PIRHttpSuccessBlock)success
                 failed:(PIRHttpFailedBlock)failed;

- (PIRHttpExecutor*)POST:(NSString*)path
              parameters:(NSDictionary*)parameters
                progress:(void (^)(float))progressBlock
                 success:(PIRHttpSuccessBlock)success
                  failed:(PIRHttpFailedBlock)failed;

@end
