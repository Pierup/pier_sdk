//
//  PierPayModel.m
//  PierPaySDK
//
//  Created by zyma on 1/26/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierPayModel.h"

@implementation PierPayModel

@end

#pragma mark - -------------------PIER_API_TRANSACTION_SMS-------------------
#pragma mark - Request

@implementation PierTransactionSMSRequest

@end

#pragma mark - Response

@interface PierTransactionSMSResponse ()
@property(nonatomic, copy, readwrite) NSString *expiration;
@property(nonatomic, copy, readwrite) NSString *sms_no;
@property(nonatomic, copy, readwrite) NSString *merchant_name;
@end

@implementation PierTransactionSMSResponse

@end


#pragma mark - -------------------PIER_API_GET_AUTH_TOKEN_V2-------------------
#pragma mark - Request
@implementation PierGetAuthTokenV2Request


@end

#pragma mark - Response

@interface PierGetAuthTokenV2Response ()
@property(nonatomic, copy, readwrite) NSString *auth_token;
@end

@implementation PierGetAuthTokenV2Response

@end

#pragma mark - --------------------PIER_API_GET_ACTIVITY_CODE-------------------
#pragma mark - Request
@implementation PierGetRegisterCodeRequest

@end

@interface PierGetRegisterCodeResponse ()
@property(nonatomic, copy, readwrite) NSString *expiration;
@end

@implementation PierGetRegisterCodeResponse

@end


#pragma mark - --------------------PIER_API_GET_ACTIVITION-------------------
#pragma mark - Request
@implementation PierRegSMSActiveRequest

@end

#pragma mark - Response
@interface PierRegSMSActiveResponse ()
@property(nonatomic, copy, readwrite) NSString *token;
@end

@implementation PierRegSMSActiveResponse

@end


#pragma mark - --------------------PIER_API_GET_ACTIVITION_REGIST-------------------
#pragma mark - Request
@implementation PierRegisterRequest

@end

#pragma mark - Response

@interface PierRegisterResponse ()
@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readwrite) NSString *device_id;
@property(nonatomic, copy, readwrite) NSString *passcode_expiration;
@end

@implementation PierRegisterResponse

@end

#pragma mark - --------------------PIER_API_GET_GETUSER----------------------
#pragma mark - Request
@implementation PierGetUserRequest
@end

#pragma mark - Response
@interface PierGetUserResponse ()
@property(nonatomic, copy, readwrite) NSString *address;
@property(nonatomic, copy, readwrite) NSString *dob;
@property(nonatomic, copy, readwrite) NSString *email;
@property(nonatomic, copy, readwrite) NSString *first_name;
@property(nonatomic, copy, readwrite) NSString *last_name;
@property(nonatomic, copy, readwrite) NSString *ssn;
@end

@implementation PierGetUserResponse

@end


#pragma mark - --------------------PIER_API_GET_UPDATEUSER-------------------
#pragma mark - Request
@interface PierUpdateRequest ()
@end

@implementation PierUpdateRequest
@end

#pragma mark - Response
@interface PierUpdateResponse ()
@property(nonatomic, copy, readwrite) NSString *status_bit;
@end

@implementation PierUpdateResponse
@end

#pragma mark - --------------------PIER_API_GET_APPLYCREDIT-------------------
#pragma mark - Request
@interface PierCreditApplyRequest()
@end

@implementation PierCreditApplyRequest

@end

#pragma mark - Response
@interface PierCreditApplyResponse()
@property(nonatomic, copy, readwrite) NSString *currency;
@property(nonatomic, copy, readwrite) NSString *category;
@property(nonatomic, copy, readwrite) NSString *credit_limit;
@property(nonatomic, copy, readwrite) NSString *shadow_limit;
@property(nonatomic, copy, readwrite) NSString *note;
@end

@implementation PierCreditApplyResponse

@end

#pragma mark - --------------------ePIER_API_GET_MERCHANT-------------------
#pragma mark - Request
@implementation PierMerchantRequest
@end

#pragma mark - Response
@implementation PierMerchantResponse
@end

#pragma mark - ---------------------ePIER_API_GET_COUNTRYS-------------------
#pragma mark - Request

@interface PierCountryCodeRequest ()
@end

@implementation PierCountryCodeRequest

@end

@interface PierCountry()
//@property (nonatomic, copy, readwrite) NSString *code;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *phone_prefix;
@property (nonatomic, copy, readwrite) NSString *phone_size;
@end

@implementation PierCountry

@end

@implementation PierCountryCodeResponse
@end

#pragma mark - ---------------------ePIER_APU_GET_URLS-----------------------
#pragma mark - Request
@interface PierUserAgreementRequest ()

@end

@implementation PierUserAgreementRequest

@end

#pragma mark - Response
@interface PierUserAgreementResponse ()
@property (nonatomic, copy, readwrite) NSString * url_privacy;
@property (nonatomic, copy, readwrite) NSString * url_term;
@end

@implementation PierUserAgreementResponse

@end