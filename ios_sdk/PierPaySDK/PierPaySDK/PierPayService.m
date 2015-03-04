//
//  PierPayService.m
//  PierPaySDK
//
//  Created by zyma on 3/4/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierPayService.h"
#import "PIRService.h"
#import "PierAlertView.h"
#import "PIRDataSource.h"

@implementation PierPayService

- (void)serviceGetPaySMS{
    [PIRService serverSend:ePIER_API_TRANSACTION_SMS resuest:self.smsRequestModel successBlock:^(id responseModel) {
        TransactionSMSResponse *response = (TransactionSMSResponse *)responseModel;
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"",@"titleImageName",
                               @"SMS",@"title",
                               @"Pay",@"approveText",
                               @"Cancel",@"cancleText",
                               self.smsRequestModel.phone,@"phone",
                               response.expiration,@"expirationTime",nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [PierSMSAlertView showPierUserInputAlertView:self param:param type:ePierAlertViewType_userInput approve:^(NSString *userInput) {
                [self serviceGetAuthToken:userInput];
            } cancel:^{
                
            }];
        });
    } faliedBlock:^(NSError *error) {
        
    }];
}

- (void)serviceGetAuthToken:(NSString *)userinput{
    self.authTokenRequestModel.phone = __dataSource.phone;
    self.authTokenRequestModel.pass_code = userinput;
    self.authTokenRequestModel.pass_type = @"1";
    self.authTokenRequestModel.merchant_id = [__dataSource.merchantParam objectForKey:@"merchant_id"];
    self.authTokenRequestModel.amount = [__dataSource.merchantParam objectForKey:@"amount"];
    self.authTokenRequestModel.currency_code = [__dataSource.merchantParam objectForKey:@"currency"];
    
    [PIRService serverSend:ePIER_API_GET_AUTH_TOKEN_V2 resuest:self.authTokenRequestModel successBlock:^(id responseModel) {
        GetAuthTokenV2Response *response = (GetAuthTokenV2Response *)responseModel;
        [self serviceMerchantService:response];
    } faliedBlock:^(NSError *error) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"1",@"status",
                                [error domain],@"message", nil];
        [self pierPayComplete:result];
    }];
}

- (void)serviceMerchantService:(GetAuthTokenV2Response *)resultModel{
    MerchantRequest *requestModel = [[MerchantRequest alloc] init];
    requestModel.auth_token = resultModel.auth_token;
    [PIRService serverSend:ePIER_API_GET_MERCHANT resuest:requestModel successBlock:^(id responseModel) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"0",@"status",
                                @"success",@"message", nil];
        [self pierPayComplete:result];
    } faliedBlock:^(NSError *error) {
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"1",@"status",
                                [error domain],@"message", nil];
        [self pierPayComplete:result];
    }];
}

/**
 * pay by pier conmpete!
 */
- (void)pierPayComplete:(NSDictionary *)result{
    [__dataSource.pierDelegate payByPierComplete:result];
}


@end
