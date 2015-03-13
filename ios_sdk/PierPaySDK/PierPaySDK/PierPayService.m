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

@interface PierPayService () <PierSMSInputAlertDelegate>

@property (nonatomic, strong) GetAuthTokenV2Request *authTokenRequestModel;

@property (nonatomic, strong) PierSMSAlertView *smsAlertView;

@end

@implementation PierPayService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authTokenRequestModel = [[GetAuthTokenV2Request alloc] init];
    }
    return self;
}

- (void)serviceGetPaySMS{
    [PIRService serverSend:ePIER_API_TRANSACTION_SMS resuest:self.smsRequestModel successBlock:^(id responseModel) {
        TransactionSMSResponse *response = (TransactionSMSResponse *)responseModel;
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"",@"title_image_name",
                               @"SMS",@"title",
                               @"Pay",@"approve_text",
                               @"Cancel",@"cancle_text",
                               self.smsRequestModel.phone,@"phone",
                               response.expiration,@"expiration_time",
                               @"6",@"code_length",nil];
        _smsAlertView = [[PierSMSAlertView alloc] initWith:self param:param type:ePierAlertViewType_instance];
        _smsAlertView.delegate = self;
        [_smsAlertView show];
        
    } faliedBlock:^(NSError *error) {

    } attribute:nil];
}


- (void)serviceGetAuthToken:(NSString *)userinput{
    self.authTokenRequestModel.phone = __dataSource.phone;
    self.authTokenRequestModel.pass_code = userinput;
    self.authTokenRequestModel.pass_type = @"1";
    self.authTokenRequestModel.merchant_id = [__dataSource.merchantParam objectForKey:@"merchant_id"];
    self.authTokenRequestModel.amount = [__dataSource.merchantParam objectForKey:@"amount"];
    self.authTokenRequestModel.currency_code = [__dataSource.merchantParam objectForKey:@"currency"];
    
    [PIRService serverSend:ePIER_API_GET_AUTH_TOKEN_V2 resuest:self.authTokenRequestModel successBlock:^(id responseModel) {
        [_smsAlertView dismiss];
        GetAuthTokenV2Response *response = (GetAuthTokenV2Response *)responseModel;
        [self serviceMerchantService:response];
    } faliedBlock:^(NSError *error) {
        [_smsAlertView showErrorMessage:[error domain]];
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"show_alert",@"1",@"show_loading", nil]];
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
    } attribute:nil];
}

/**
 * pay by pier complete!
 */
- (void)pierPayComplete:(NSDictionary *)result{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pierPayServiceComplete:)]) {
        [self.delegate pierPayServiceComplete:result];
    }
}

#pragma mark - ---------------------------- PierSMSInputAlertView ----------------------------

- (void)userApprove:(NSString *)userInput{
    [self serviceGetAuthToken:userInput];
}

@end
