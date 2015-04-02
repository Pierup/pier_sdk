//
//  PierPayService.m
//  PierPaySDK
//
//  Created by zyma on 3/4/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierPayService.h"
#import "PierService.h"
#import "PierAlertView.h"
#import "PierDataSource.h"
#import "NSString+PierCheck.h"
#import "PierDataSource.h"
#import "PierViewUtil.h"

/**
 * status_bit user 7th to 13th bits to denote nine status：
 * Invited: the phone account whether invited.
 * BasicInfo: the phone account whether update basic user info (first name, last name, email.)
 * billAddress: the phone account whether push bill address into system.
 * Ssn: the phone account whether push ssn and dob info into system.
 * linkAccount: the phone account whether linked a bank account.
 * hasApplied: the phone account whether has applied pier account.
 * HasCredit: the phone account whether has a pier credit account.
 */
typedef enum {
    eUserStatus_new_user        = 0,
    eUserStatus_invited         = 1 << 0,
    eUserStatus_basicInfo       = 1 << 1,
    eUserStatus_billAddress     = 1 << 2,
    eUserStatus_ssn             = 1 << 3,
    eUserStatus_linkAccount     = 1 << 4,
    eUserStatus_hasApplied      = 1 << 5,
    eUserStatus_hasCredit       = 1 << 6,
    eUserStatus_hasPassCode     = 1 << 7,
    eUserStatus_reigsterUser,
    eUserStatus_reApply
}eUserStatus;

@interface PierPayService () <PierSMSInputAlertDelegate>

@property (nonatomic, strong) PierGetAuthTokenV2Request *authTokenRequestModel;

@property (nonatomic, strong) PierSMSAlertView *smsAlertView;

@property (nonatomic, assign) ePierPayWith payWithType;

@end

@implementation PierPayService

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authTokenRequestModel = [[PierGetAuthTokenV2Request alloc] init];
    }
    return self;
}

- (void)serviceGetPaySMS{
    [self serviceGetPaySMS:YES payWith:ePierPayWith_Merchant_oldUser];
}

- (void)serviceGetPaySMS:(BOOL)rememberuser payWith:(ePierPayWith)payWith{
    self.payWithType = payWith;
    [PierService serverSend:ePIER_API_TRANSACTION_SMS resuest:self.smsRequestModel successBlock:^(id responseModel) {

        PierTransactionSMSResponse *response = (PierTransactionSMSResponse *)responseModel;
        NSInteger creditMap = ([response.status_bit integerValue] >> 6);
        if ((creditMap & eUserStatus_hasCredit) == eUserStatus_hasCredit){//Has Credit.
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"",@"title_image_name",
                                   @"Transaction Verification Code",@"title",
                                   @"Pay",@"approve_text",
                                   @"Cancel",@"cancle_text",
                                   self.smsRequestModel.phone,@"phone",
                                   response.expiration,@"expiration_time",
                                   [__pierDataSource.merchantParam objectForKey:DATASOURCES_AMOUNT],@"amount",
                                   @"6",@"code_length",nil];
            
            ePierAlertViewType alertType = ePierAlertViewType_instance;
            switch (payWith) {
                case ePierPayWith_Merchant:
                    alertType = ePierAlertViewType_instance;
                    break;
                case ePierPayWith_Merchant_oldUser:
                    alertType = ePierAlertViewType_instance_oldUser;
                    break;
                default:
                    break;
            }
            
            _smsAlertView = [[PierSMSAlertView alloc] initWith:self param:param type:alertType];
            _smsAlertView.delegate = self;
            [_smsAlertView showErrorMessage:@""];
            [_smsAlertView show];
            
            if (rememberuser) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     self.smsRequestModel.phone, pier_userdefaults_phone,
                                     [__pierDataSource.merchantParam objectForKey:DATASOURCES_COUNTRY_CODE], pier_userdefaults_countrycode,
                                     self.smsRequestModel.password, pier_userdefaults_password,nil];
                [__pierDataSource saveUserInfo:dic];
            }else{
                [__pierDataSource clearUserInfo];
            }
            
        }else{
            if (self.payWithType == ePierPayWith_Merchant || self.payWithType == ePierPayWith_Merchant_oldUser){
                //没有信用让用户去填写信息
                [PierViewUtil toCreditApplyViewController:response];
            }
        }

    } faliedBlock:^(NSError *error) {
        if (self.payWithType == ePierPayWith_Merchant || self.payWithType == ePierPayWith_Merchant_oldUser) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(pierPayServiceFailed:)]) {
                [self.delegate pierPayServiceFailed:error];
            }
        }else if (self.payWithType == ePierPayWith_PierApp){
            //Get mss failed in pierApp show alertView.
            NSDictionary *alertParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"icon_error",@"title_image_name",
                                        @"error",@"title",
                                        [error domain],@"message",nil];
            [PierAlertView showPierAlertView:self param:alertParam type:ePierAlertViewType_error approve:^(NSString *userInput) {
                return YES;
            }];
        }
        [_smsAlertView showErrorMessage:[error domain]];
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:
                 @"1", @"show_alert",
                 @"0", @"show_loading",
                 @"Pier Payment", @"show_message", nil]];
}

//ReSend TextMessage
- (void)rSendServicePaySMS{
    [PierService serverSend:ePIER_API_TRANSACTION_SMS resuest:self.smsRequestModel successBlock:^(id responseModel) {
        PierTransactionSMSResponse *response = (PierTransactionSMSResponse *)responseModel;
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"",@"title_image_name",
                               @"Transaction Verification Code",@"title",
                               @"Pay",@"approve_text",
                               @"Cancel",@"cancle_text",
                               self.smsRequestModel.phone,@"phone",
                               response.expiration,@"expiration_time",
                               [__pierDataSource.merchantParam objectForKey:DATASOURCES_AMOUNT],@"amount",
                               @"6",@"code_length",nil];
        if (!_smsAlertView) {
            _smsAlertView = [[PierSMSAlertView alloc] initWith:self param:param type:ePierAlertViewType_instance];
            _smsAlertView.delegate = self;
            [_smsAlertView show];
        }else{
            [_smsAlertView refreshTimer:param];
        }
        [_smsAlertView showErrorMessage:@""];
    } faliedBlock:^(NSError *error) {
        [_smsAlertView showErrorMessage:[error domain]];
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:
                 @"1", @"show_alert",
                 @"0", @"show_loading",
                 @"Pier Payment", @"show_message", nil]];
}

- (void)serviceGetAuthToken:(NSString *)userinput type:(ePierPaymentType) type{
    self.authTokenRequestModel.phone = [__pierDataSource.merchantParam objectForKey:DATASOURCES_PHONE];
    if (type == ePierPaymentType_TouchID) {
        self.authTokenRequestModel.device_token = userinput;
    }else{
        self.authTokenRequestModel.pass_code = userinput;
    }
    
    self.authTokenRequestModel.pass_type = [NSString stringWithFormat:@"%ld",(long)type];
    self.authTokenRequestModel.merchant_id = [__pierDataSource.merchantParam objectForKey:@"merchant_id"];
    self.authTokenRequestModel.amount = [__pierDataSource.merchantParam objectForKey:@"amount"];
    self.authTokenRequestModel.currency_code = [__pierDataSource.merchantParam objectForKey:@"currency"];
    
    [PierService serverSend:ePIER_API_GET_AUTH_TOKEN_V2 resuest:self.authTokenRequestModel successBlock:^(id responseModel) {
        [_smsAlertView dismiss];
        PierGetAuthTokenV2Response *response = (PierGetAuthTokenV2Response *)responseModel;
        [self serviceMerchantService:response];
        [_smsAlertView showErrorMessage:@""];
    } faliedBlock:^(NSError *error) {
        if (type == ePierPaymentType_TouchID) {
            //TouchID Get authToken failed show alertView.
            NSDictionary *alertParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"icon_error",@"title_image_name",
                                        @"error",@"title",
                                        [error domain],@"message",nil];
            [PierAlertView showPierAlertView:self param:alertParam type:ePierAlertViewType_error approve:^(NSString *userInput) {
                return YES;
            }];
        }
        [_smsAlertView showErrorMessage:[error domain]];
        
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:
                 @"1", @"show_alert",
                 @"0", @"show_loading",
                 @"Pier Payment", @"show_message", nil]];
}

- (void)serviceMerchantService:(PierGetAuthTokenV2Response *)resultModel{
    PierMerchantRequest *requestModel = [[PierMerchantRequest alloc] init];
    requestModel.auth_token = resultModel.auth_token;
    [PierService serverSend:ePIER_API_GET_MERCHANT resuest:requestModel successBlock:^(id responseModel) {
        NSString *amount = [NSString getNumberFormatterDecimalStyle:[__pierDataSource.merchantParam objectForKey:@"amount"] currency:[__pierDataSource.merchantParam objectForKey:@"currency"]];
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"0",@"status",
                                @"success",@"message",
                                amount ,@"spending", nil];
        [self pierPayComplete:result];
        [_smsAlertView showErrorMessage:@""];
    } faliedBlock:^(NSError *error) {
        [_smsAlertView showErrorMessage:[error domain]];
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys://支付出错，需要从新获取auto token，这里直接走失败回调。
                 @"0", @"show_alert",
                 @"0", @"show_loading",
                 @"Pier Payment", @"show_message", nil]];
}

/**
 * pay by pier complete!
 */
- (void)pierPayComplete:(NSDictionary *)result{
    if (self.payWithType == ePierPayWith_Merchant || self.payWithType == ePierPayWith_Merchant_oldUser) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pierPayServiceComplete:)]) {
            [self.delegate pierPayServiceComplete:result];
            [_smsAlertView dismiss];
        }
    }else{
        if (__pierDataSource.pierDelegate && [__pierDataSource.pierDelegate respondsToSelector:@selector(payWithPierComplete:)]) {
            NSString *amount = [NSString getNumberFormatterDecimalStyle:[__pierDataSource.merchantParam objectForKey:@"amount"] currency:[__pierDataSource.merchantParam objectForKey:@"currency"]];
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [mutDic setValue:amount forKey:@"Amount"];
            [__pierDataSource.pierDelegate payWithPierComplete:mutDic];
            [_smsAlertView dismiss];
        }
    }
}

#pragma mark - ---------------------------- PierSMSInputAlertView ----------------------------
- (void)userApprove:(NSString *)userInput{
    [self serviceGetAuthToken:userInput type:ePierPaymentType_SMS];
}

- (void)userCancel{
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1",@"status",
                            @"Payment Cancel",@"message", nil];
    [self pierPayComplete:result];
}

- (void)resendTextMessage{
    //resend payment text message
    [self rSendServicePaySMS];
}

- (void)changeAccount{
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"2",@"status",
                            @"Change Account",@"message", nil];
    [self pierPayComplete:result];
}

@end
