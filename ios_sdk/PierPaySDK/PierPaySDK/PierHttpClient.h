//
//  PIRHttpClient.h
//  PierPaySDK
//
//  Created by zyma on 12/15/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PierHttpExecutor;

/** success block */
typedef void (^PIRHttpSuccessBlock)(id response, NSHTTPURLResponse *urlResponse);
/** failed block */
typedef void (^PIRHttpFailedBlock)(NSHTTPURLResponse *urlResponse, NSError *error);

typedef enum {
    ePIRHttpClientType_User         =   0,
    ePIRHttpClientType_User_V2      =   1,
    ePIRHttpClientType_Empty        =   2
}ePIRHttpClientType;

@interface PierHttpClient : NSObject

+ (PierHttpClient *)sharedInstanceWithClientType:(ePIRHttpClientType)type;

- (PierHttpExecutor*)GET:(NSString*)path
             saveToPath:(NSString*)savePath
             parameters:(NSDictionary*)parameters
               progress:(void (^)(float))progressBlock
                success:(PIRHttpSuccessBlock)success
                 failed:(PIRHttpFailedBlock)failed;

- (PierHttpExecutor*)POST:(NSString*)path
              parameters:(NSDictionary*)parameters
                progress:(void (^)(float))progressBlock
                 success:(PIRHttpSuccessBlock)success
                  failed:(PIRHttpFailedBlock)failed;

- (PierHttpExecutor*)JSONPOST:(NSString*)path
                  parameters:(NSDictionary*)parameters
                    progress:(void (^)(float))progressBlock
                     success:(PIRHttpSuccessBlock)success
                      failed:(PIRHttpFailedBlock)failed;

- (PierHttpExecutor*)UploadImage:(NSString*)path
                     parameters:(NSDictionary*)parameters
                       progress:(void (^)(float))progressBlock
                        success:(PIRHttpSuccessBlock)success
                         failed:(PIRHttpFailedBlock)failed;

- (PierHttpExecutor*)PUT:(NSString*)path
              parameters:(NSDictionary*)parameters
                progress:(void (^)(float))progressBlock
                 success:(PIRHttpSuccessBlock)success
                  failed:(PIRHttpFailedBlock)failed;

- (PierHttpExecutor*)JSONPUT:(NSString*)path
                 parameters:(NSDictionary*)parameters
                   progress:(void (^)(float))progressBlock
                    success:(PIRHttpSuccessBlock)success
                     failed:(PIRHttpFailedBlock)failed;

- (void)cancelAllRequests;
@end
