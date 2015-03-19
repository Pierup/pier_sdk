//
//  PierHttpClient.h
//  PierPaySDK
//
//  Created by zyma on 12/15/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PierHttpExecutor;

/** success block */
typedef void (^PierHttpSuccessBlock)(id response, NSHTTPURLResponse *urlResponse);
/** failed block */
typedef void (^PierHttpFailedBlock)(NSHTTPURLResponse *urlResponse, NSError *error);

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
                success:(PierHttpSuccessBlock)success
                 failed:(PierHttpFailedBlock)failed;

- (PierHttpExecutor*)POST:(NSString*)path
              parameters:(NSDictionary*)parameters
                progress:(void (^)(float))progressBlock
                 success:(PierHttpSuccessBlock)success
                  failed:(PierHttpFailedBlock)failed;

- (PierHttpExecutor*)JSONPOST:(NSString*)path
                  parameters:(NSDictionary*)parameters
                    progress:(void (^)(float))progressBlock
                     success:(PierHttpSuccessBlock)success
                      failed:(PierHttpFailedBlock)failed;

- (PierHttpExecutor*)UploadImage:(NSString*)path
                     parameters:(NSDictionary*)parameters
                       progress:(void (^)(float))progressBlock
                        success:(PierHttpSuccessBlock)success
                         failed:(PierHttpFailedBlock)failed;

- (PierHttpExecutor*)PUT:(NSString*)path
              parameters:(NSDictionary*)parameters
                progress:(void (^)(float))progressBlock
                 success:(PierHttpSuccessBlock)success
                  failed:(PierHttpFailedBlock)failed;

- (PierHttpExecutor*)JSONPUT:(NSString*)path
                 parameters:(NSDictionary*)parameters
                   progress:(void (^)(float))progressBlock
                    success:(PierHttpSuccessBlock)success
                     failed:(PierHttpFailedBlock)failed;

- (void)cancelAllRequests;
@end
