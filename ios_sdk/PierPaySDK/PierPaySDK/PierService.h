//
//  PierService.h
//  PierPaySDK
//
//  Created by zyma on 1/13/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PierPayModel.h"

typedef enum {
    ePIER_API_TRANSACTION_SMS,
    ePIER_API_GET_AUTH_TOKEN_V2,//V2
    ePIER_API_GET_ACTIVITY_CODE,
    ePIER_API_GET_ACTIVITION,
    ePIER_API_GET_ACTIVITION_REGIST,
    ePIER_API_GET_UPDATEUSER,
    ePIER_API_GET_GETUSER,
    ePIER_API_GET_APPLYCREDIT,
    /** merchant */
    ePIER_API_GET_MERCHANT,
    ePIER_API_GET_COUNTRYS,
    ePIER_APU_GET_URLS
}ePIER_API_Type;

/** V1 */
extern NSString * const PIER_API_SEARCH_USER;
extern NSString * const PIER_API_HAS_CREDIT;
extern NSString * const PIER_API_ADD_SUER;
extern NSString * const PIER_API_ACTIVITE_DEVICE;
extern NSString * const PIER_API_ADD_ADDRESS;
extern NSString * const PIER_API_SET_PASSWORD;
extern NSString * const PIER_API_GET_AUTH_TOKEN;
extern NSString * const PIER_API_SAVE_DOB_SSN;
extern NSString * const PIER_API_GET_AGREEMENT;
extern NSString * const PIER_API_CREDIT_APPLICATION;

/** V2 */
extern NSString * const PIER_API_TRANSACTION_SMS;
extern NSString * const PIER_API_GET_AUTH_TOKEN_V2;

extern NSString * const PIER_API_GET_ACTIVITY_CODE;
extern NSString * const PIER_API_GET_ACTIVITION;
extern NSString * const PIER_API_GET_ACTIVITION_REGIST;
extern NSString * const PIER_API_GET_UPDATEUSER;
extern NSString * const PIER_API_GET_GETUSER;
extern NSString * const PIER_API_GET_APPLYCREDIT;
extern NSString * const PIER_API_GET_COUNTRYS;
extern NSString * const PIER_APU_GET_URLS;

/** success block */
typedef void (^PierPaySuccessBlock)(id responseModel);
/** failed block */
typedef void (^PierPayFailedBlock)(NSError *error);

@interface PierService : NSObject

/**
 * show_alert   0:show 1:not default:0
 * show_message NSString 
 * show_loading 0:show 1:not default:0
 */
+ (void)serverSend:(ePIER_API_Type)apiType
           resuest:(PierPayModel *)requestModel
      successBlock:(PierPaySuccessBlock)success
       faliedBlock:(PierPayFailedBlock)failed
         attribute:(NSDictionary *)attribute;

@end
