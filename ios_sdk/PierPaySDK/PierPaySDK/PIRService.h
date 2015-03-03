//
//  PIRService.h
//  PierPaySDK
//
//  Created by zyma on 1/13/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIRPayModel.h"

typedef enum {
    ePIER_API_TRANSACTION_SMS,
    ePIER_API_GET_AUTH_TOKEN_V2,//V2
    ePIER_API_GET_ACTIVITY_CODE,
    ePIER_API_GET_ACTIVITION,
    ePIER_API_GET_ACTIVITION_REGIST,
    ePIER_API_GET_UPDATEUSER
}ePIER_API_Type;


/** success block */
typedef void (^PierPaySuccessBlock)(id responseModel);
/** failed block */
typedef void (^PierPayFailedBlock)(NSError *error);

@interface PIRService : NSObject

+ (void)serverSend:(ePIER_API_Type)apiType
           resuest:(PIRPayModel *)requestModel
      successBlock:(PierPaySuccessBlock)success
       faliedBlock:(PierPayFailedBlock)failed;

@end
