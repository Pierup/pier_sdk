//
//  PierPayModel.h
//  PierPaySDK
//
//  Created by zyma on 1/26/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierJSONModel.h"

@interface PierPayModel : PierJSONModel
//input
@property(nonatomic, copy, readwrite) NSString *country_code;
//output
@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readonly)  NSString *session_token;
@property(nonatomic, copy, readwrite) NSString *code;
@property(nonatomic, copy, readwrite) NSString *message;

@end

#pragma mark - -------------------PIER_API_TRANSACTION_SMS-------------------
#pragma mark - Request
@interface PierTransactionSMSRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *password;
@property(nonatomic, copy, readwrite) NSString *merchant_id;
@property(nonatomic, copy, readwrite) NSString *amount;
@property(nonatomic, copy, readwrite) NSString *currency_code;

@end

#pragma mark - Response
@interface PierTransactionSMSResponse : PierPayModel

@property(nonatomic, copy, readonly) NSString *expiration;
@property(nonatomic, copy, readonly) NSString *sms_no;
@property(nonatomic, copy, readonly) NSString *merchant_name;
@property(nonatomic, copy, readonly) NSString *status_bit;

@end

#pragma mark - -------------------PIER_API_GET_AUTH_TOKEN_V2-------------------
#pragma mark - Request
@interface PierGetAuthTokenV2Request : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *pass_code;
@property(nonatomic, copy, readwrite) NSString *pass_type;
@property(nonatomic, copy, readwrite) NSString *merchant_id;
@property(nonatomic, copy, readwrite) NSString *amount;
@property(nonatomic, copy, readwrite) NSString *currency_code;
@property(nonatomic, copy, readwrite) NSString *device_token;

@end

#pragma mark - Response
@interface PierGetAuthTokenV2Response : PierPayModel

@property(nonatomic, copy, readonly) NSString *auth_token;

@end

#pragma mark - --------------------PIER_API_GET_ACTIVITY_CODE-------------------
#pragma mark - Request
@interface PierGetRegisterCodeRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@end

#pragma mark - Response
@interface PierGetRegisterCodeResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *expiration;
@end

#pragma mark - --------------------PIER_API_GET_ACTIVITION-------------------
#pragma mark - Request

@interface PierRegSMSActiveRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *activation_code;
@end

#pragma mark - Response
@interface PierRegSMSActiveResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *token;
@end

#pragma mark - --------------------PIER_API_GET_ACTIVITION_REGIST-------------------
#pragma mark - Request
@interface PierRegisterRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *token;
@property(nonatomic, copy, readwrite) NSString *password;
@end

#pragma mark - Response
@interface PierRegisterResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *device_id;
@property(nonatomic, copy, readonly) NSString *passcode_expiration;

@end

#pragma mark - --------------------PIER_API_GET_GETUSER----------------------
#pragma mark - Request
@interface PierGetUserRequest : PierPayModel
@end

#pragma mark - Response
@interface PierGetUserResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *address;
@property(nonatomic, copy, readonly) NSString *dob;
@property(nonatomic, copy, readonly) NSString *email;
@property(nonatomic, copy, readonly) NSString *first_name;
@property(nonatomic, copy, readonly) NSString *last_name;
@property(nonatomic, copy, readonly) NSString *ssn;
@end

#pragma mark - --------------------PIER_API_GET_UPDATEUSER-------------------
#pragma mark - Request
@interface PierUpdateRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *first_name;
@property(nonatomic, copy, readwrite) NSString *last_name;
@property(nonatomic, copy, readwrite) NSString *email;
@property(nonatomic, copy, readwrite) NSString *dob;
@property(nonatomic, copy, readwrite) NSString *ssn;
@property(nonatomic, copy, readwrite) NSString *address;
@end

#pragma mark - Response
@interface PierUpdateResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *status_bit;
@end

#pragma mark - --------------------PIER_API_GET_APPLYCREDIT-------------------
#pragma mark - Request
@interface PierCreditApplyRequest : PierPayModel
@end

#pragma mark - Response
@interface PierCreditApplyResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *currency;
@property(nonatomic, copy, readonly) NSString *category;
@property(nonatomic, copy, readonly) NSString *credit_limit;
@property(nonatomic, copy, readonly) NSString *shadow_limit;
@property(nonatomic, copy, readonly) NSString *note;
@end

#pragma mark - --------------------ePIER_API_GET_MERCHANT-------------------
#pragma mark - Request
@interface PierMerchantRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *auth_token;
@end

#pragma mark - Response
@interface PierMerchantResponse : PierPayModel
@end

#pragma mark - ---------------------ePIER_API_GET_COUNTRYS-------------------
#pragma mark - Request

@interface PierCountryCodeRequest : PierPayModel
@end

@protocol PierCountry @end
@interface PierCountry : PierPayModel
//@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *phone_prefix;
@property (nonatomic, copy, readonly) NSString *phone_size;
@end

@interface PierCountryCodeResponse : PierPayModel
@property (nonatomic, strong) NSMutableArray<PierCountry> *items;
@end

#pragma mark - ---------------------ePIER_APU_GET_URLS-----------------------
#pragma mark - Request
@interface PierUserAgreementRequest : PierPayModel

@end

#pragma mark - Response
@interface PierUserAgreementResponse : PierPayModel
@property (nonatomic, copy, readonly) NSString * url_privacy;
@property (nonatomic, copy, readonly) NSString * url_term;
@end
