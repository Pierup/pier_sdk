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
@property(nonatomic, copy, readwrite) NSString *session_token;
@property(nonatomic, copy, readwrite) NSString *passcode_expiration;
@end

@implementation RegisterResponse

@end

