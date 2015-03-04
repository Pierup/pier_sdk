//
//  PierPayService.h
//  PierPaySDK
//
//  Created by zyma on 3/4/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIRPayModel.h"

@interface PierPayService : NSObject

/** servire model */
@property (nonatomic, strong) TransactionSMSRequest *smsRequestModel;
@property (nonatomic, strong) GetAuthTokenV2Request *authTokenRequestModel;

- (void)serviceGetPaySMS;

@end
