//
//  PIRPayModel.h
//  PierPaySDK
//
//  Created by zyma on 1/26/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PIRJSONModel.h"

@interface PIRPayModel : PIRJSONModel
//input
@property(nonatomic, copy, readwrite) NSString *country_code;
//output
@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readonly) NSString *session_token;
@property(nonatomic, copy, readwrite) NSString *code;
@property(nonatomic, copy, readwrite) NSString *message;

@end

#pragma mark - -------------------PIER_API_TRANSACTION_SMS-------------------
#pragma mark - Request
@interface TransactionSMSRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@end

#pragma mark - Response
@interface TransactionSMSResponse : PIRPayModel

@property(nonatomic, copy, readonly) NSString *expiration;
@property(nonatomic, copy, readonly) NSString *sms_no;

@end

#pragma mark - -------------------PIER_API_GET_AUTH_TOKEN_V2-------------------
#pragma mark - Request
@interface GetAuthTokenV2Request : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *merchant_id;
@property(nonatomic, copy, readwrite) NSString *amount;
@property(nonatomic, copy, readwrite) NSString *currency_code;
@end

#pragma mark - Response
@interface GetAuthTokenV2Response : PIRPayModel

@property(nonatomic, copy, readonly) NSString *auth_token;

@end

#pragma mark - --------------------PIER_API_GET_ACTIVITY_CODE-------------------
#pragma mark - Request
@interface GetRegisterCodeRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@end

#pragma mark - Response
@interface GetRegisterCodeResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *expiration;
@end

#pragma mark - --------------------PIER_API_GET_ACTIVITION-------------------
#pragma mark - Request

@interface RegSMSActiveRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *activation_code;
@end

#pragma mark - Response
@interface RegSMSActiveResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *token;
@end

#pragma mark - --------------------PIER_API_GET_ACTIVITION_REGIST-------------------
#pragma mark - Request
@interface RegisterRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *token;
@property(nonatomic, copy, readwrite) NSString *country_code;
@property(nonatomic, copy, readwrite) NSString *password;
@end

#pragma mark - Response
@interface RegisterResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *device_id;
@property(nonatomic, copy, readonly) NSString *passcode_expiration;

@end

#pragma mark - --------------------PIER_API_GET_UPDATEUSER-------------------
#pragma mark - Request
@interface UpdateRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *first_name;
@property(nonatomic, copy, readwrite) NSString *last_name;
@property(nonatomic, copy, readwrite) NSString *email;
@property(nonatomic, copy, readwrite) NSString *dob;
@property(nonatomic, copy, readwrite) NSString *ssn;
@property(nonatomic, copy, readwrite) NSString *address;
@end

#pragma mark - Response
@interface UpdateResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *status_bit;
@end

#pragma mark - --------------------PIER_API_GET_APPLYCREDIT-------------------
#pragma mark - Request
@interface CreditApplyRequest : PIRPayModel
@end

#pragma mark - Response
@interface CreditApplyResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *currency;
@property(nonatomic, copy, readonly) NSString *category;
@property(nonatomic, copy, readonly) NSString *credit_limit;
@property(nonatomic, copy, readonly) NSString *shadow_limit;
@property(nonatomic, copy, readonly) NSString *note;
@end
