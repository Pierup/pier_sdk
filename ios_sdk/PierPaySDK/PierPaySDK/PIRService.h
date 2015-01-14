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
    ePIER_API_SEARCH_USER,
    ePIER_API_HAS_CREDIT,
    ePIER_API_ADD_SUER,
    ePIER_API_ACTIVITE_DEVICE,
    ePIER_API_ADD_ADDRESS,
    ePIER_API_SET_PASSWORD,
    ePIER_API_GET_AUTH_TOKEN,
    ePIER_API_SAVE_DOB_SSN,
    ePIER_API_GET_AGREEMENT,
    ePIER_API_CREDIT_APPLICATION
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
