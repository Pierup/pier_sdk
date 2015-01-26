//
//  PIRPayModel.h
//  PierPaySDK
//
//  Created by zyma on 1/26/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PIRJSONModel.h"

@interface PIRPayModel : PIRJSONModel
@property(nonatomic, copy, readwrite) NSString *code;
@property(nonatomic, copy, readwrite) NSString *message;
@end

#pragma mark - -------------------PIER_API_TRANSACTION_SMS-------------------
#pragma mark - Request
@interface TransactionSMSRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *country_code;
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
@property(nonatomic, copy, readwrite) NSString *country_code;
@property(nonatomic, copy, readwrite) NSString *merchant_id;
@property(nonatomic, copy, readwrite) NSString *amount;
@property(nonatomic, copy, readwrite) NSString *currency_code;
@end

#pragma mark - Response
@interface GetAuthTokenV2Response : PIRPayModel

@property(nonatomic, copy, readonly) NSString *auth_token;

@end