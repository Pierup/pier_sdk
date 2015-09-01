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
    ePIER_API_1,
}ePIER_API_Type;

/** V1 */
extern NSString * const PIER_API_1;
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
