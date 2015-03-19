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
@interface TransactionSMSRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *password;
@end

#pragma mark - Response
@interface TransactionSMSResponse : PierPayModel

@property(nonatomic, copy, readonly) NSString *expiration;
@property(nonatomic, copy, readonly) NSString *sms_no;

@end

#pragma mark - -------------------PIER_API_GET_AUTH_TOKEN_V2-------------------
#pragma mark - Request
@interface GetAuthTokenV2Request : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *pass_code;
@property(nonatomic, copy, readwrite) NSString *pass_type;
@property(nonatomic, copy, readwrite) NSString *merchant_id;
@property(nonatomic, copy, readwrite) NSString *amount;
@property(nonatomic, copy, readwrite) NSString *currency_code;
@end

#pragma mark - Response
@interface GetAuthTokenV2Response : PierPayModel

@property(nonatomic, copy, readonly) NSString *auth_token;

@end

#pragma mark - --------------------PIER_API_GET_ACTIVITY_CODE-------------------
#pragma mark - Request
@interface GetRegisterCodeRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@end

#pragma mark - Response
@interface GetRegisterCodeResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *expiration;
@end

#pragma mark - --------------------PIER_API_GET_ACTIVITION-------------------
#pragma mark - Request

@interface RegSMSActiveRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *activation_code;
@end

#pragma mark - Response
@interface RegSMSActiveResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *token;
@end

#pragma mark - --------------------PIER_API_GET_ACTIVITION_REGIST-------------------
#pragma mark - Request
@interface RegisterRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *token;
@property(nonatomic, copy, readwrite) NSString *country_code;
@property(nonatomic, copy, readwrite) NSString *password;
@end

#pragma mark - Response
@interface RegisterResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *device_id;
@property(nonatomic, copy, readonly) NSString *passcode_expiration;

@end

#pragma mark - --------------------PIER_API_GET_UPDATEUSER-------------------
#pragma mark - Request
@interface UpdateRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *first_name;
@property(nonatomic, copy, readwrite) NSString *last_name;
@property(nonatomic, copy, readwrite) NSString *email;
@property(nonatomic, copy, readwrite) NSString *dob;
@property(nonatomic, copy, readwrite) NSString *ssn;
@property(nonatomic, copy, readwrite) NSString *address;
@end

#pragma mark - Response
@interface UpdateResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *status_bit;
@end

#pragma mark - --------------------PIER_API_GET_APPLYCREDIT-------------------
#pragma mark - Request
@interface CreditApplyRequest : PierPayModel
@end

#pragma mark - Response
@interface CreditApplyResponse : PierPayModel
@property(nonatomic, copy, readonly) NSString *currency;
@property(nonatomic, copy, readonly) NSString *category;
@property(nonatomic, copy, readonly) NSString *credit_limit;
@property(nonatomic, copy, readonly) NSString *shadow_limit;
@property(nonatomic, copy, readonly) NSString *note;
@end

#pragma mark - --------------------ePIER_API_GET_MERCHANT-------------------
#pragma mark - Request
@interface MerchantRequest : PierPayModel
@property(nonatomic, copy, readwrite) NSString *auth_token;
@end

#pragma mark - Response
@interface MerchantResponse : PierPayModel
@end

#pragma mark - ---------------------ePIER_API_GET_COUNTRYS-------------------
#pragma mark - Request

@interface CountryCodeRequest : PierPayModel
@end

@protocol Country @end
@interface Country : PierPayModel
//@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *phone_prefix;
@property (nonatomic, copy, readonly) NSString *phone_size;
@end

@interface CountryCodeResponse : PierPayModel
@property (nonatomic, strong) NSMutableArray<Country> *items;
@end


