//
//  PIRPayModel.m
//  PierPaySDK
//
//  Created by zyma on 1/26/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PIRPayModel.h"

@implementation PIRPayModel

@end

#pragma mark - -------------------PIER_API_TRANSACTION_SMS-------------------
#pragma mark - Request

@implementation TransactionSMSRequest

@end

#pragma mark - Response

@interface TransactionSMSResponse ()
@property(nonatomic, copy, readwrite) NSString *expiration;
@property(nonatomic, copy, readwrite) NSString *sms_no;
@end

@implementation TransactionSMSResponse

@end


#pragma mark - -------------------PIER_API_GET_AUTH_TOKEN_V2-------------------
#pragma mark - Request
@implementation GetAuthTokenV2Request


@end

#pragma mark - Response

@interface GetAuthTokenV2Response ()
@property(nonatomic, copy, readwrite) NSString *auth_token;
@end

@implementation GetAuthTokenV2Response

@end

#pragma mark - --------------------PIER_API_GET_ACTIVITY_CODE-------------------
#pragma mark - Request
@implementation GetRegisterCodeRequest

@end

@interface GetRegisterCodeResponse ()
@property(nonatomic, copy, readwrite) NSString *expiration;
@end

@implementation GetRegisterCodeResponse

@end


#pragma mark - --------------------PIER_API_GET_ACTIVITION-------------------
#pragma mark - Request
@implementation RegSMSActiveRequest

@end

#pragma mark - Response
@interface RegSMSActiveResponse ()
@property(nonatomic, copy, readwrite) NSString *token;
@end

@implementation RegSMSActiveResponse

@end


#pragma mark - --------------------PIER_API_GET_ACTIVITION_REGIST-------------------
#pragma mark - Request
@implementation RegisterRequest

@end

#pragma mark - Response

@interface RegisterResponse ()
@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readwrite) NSString *device_id;
@property(nonatomic, copy, readwrite) NSString *passcode_expiration;
@end

@implementation RegisterResponse

@end

#pragma mark - --------------------PIER_API_GET_UPDATEUSER-------------------
#pragma mark - Request
@interface UpdateRequest ()
@end

@implementation UpdateRequest
@end

#pragma mark - Response
@interface UpdateResponse ()
@property(nonatomic, copy, readwrite) NSString *status_bit;
@end

@implementation UpdateResponse
@end

#pragma mark - --------------------PIER_API_GET_APPLYCREDIT-------------------
#pragma mark - Request
@interface CreditApplyRequest()
@end

@implementation CreditApplyRequest

@end

#pragma mark - Response
@interface CreditApplyResponse()
@property(nonatomic, copy, readwrite) NSString *currency;
@property(nonatomic, copy, readwrite) NSString *category;
@property(nonatomic, copy, readwrite) NSString *credit_limit;
@property(nonatomic, copy, readwrite) NSString *shadow_limit;
@property(nonatomic, copy, readwrite) NSString *note;
@end

@implementation CreditApplyResponse

@end

#pragma mark - --------------------ePIER_API_GET_MERCHANT-------------------
#pragma mark - Request
@implementation MerchantRequest
@end

#pragma mark - Response
@implementation MerchantResponse
@end

#pragma mark - ---------------------ePIER_API_GET_COUNTRYS-------------------
#pragma mark - Request

@interface CountryCodeRequest ()
@end

@implementation CountryCodeRequest

@end

@interface Country()
//@property (nonatomic, copy, readwrite) NSString *code;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *phone_prefix;
@property (nonatomic, copy, readwrite) NSString *phone_size;
@end

@implementation Country

@end

@implementation CountryCodeResponse
@end