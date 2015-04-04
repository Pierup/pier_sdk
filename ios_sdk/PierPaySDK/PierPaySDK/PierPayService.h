//
//  PierPayService.h
//  PierPaySDK
//
//  Created by zyma on 3/4/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PierPayModel.h"

typedef enum {
    ePierPayWith_PierApp,
    ePierPayWith_Merchant,
    ePierPayWith_Merchant_oldUser
}ePierPayWith;

typedef enum {
    ePierPaymentType_SMS        =   1,
    ePierPaymentType_Passcode   =   2,
    ePierPaymentType_TouchID    =   3
}ePierPaymentType;

@protocol PierPayServiceDelegate <NSObject>

/**
 * status: 0:success 1:failed 2:change Account
 */
- (void)pierPayServiceComplete:(NSDictionary *)result;

- (void)pierPayServiceFailed:(NSError *)error;

@end

@interface PierPayService : NSObject

/** servire model */
@property (nonatomic, strong) PierTransactionSMSRequest *smsRequestModel;

/** delegate */
@property (nonatomic, weak) id<PierPayServiceDelegate> delegate;

/** New User */
- (void)serviceGetPaySMS:(BOOL)rememberuser payWith:(ePierPayWith)payWith;

/** Old User */
- (void)serviceGetPaySMS;

/** Get Auth Token */
- (void)serviceGetAuthToken:(NSString *)userinput type:(ePierPaymentType) type;

@end
