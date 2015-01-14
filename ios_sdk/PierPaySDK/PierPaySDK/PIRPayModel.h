//
//  PIRPayModel.h
//  PierPaySDK
//
//  Created by zyma on 12/17/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIRPayModel : NSObject

- (PIRPayModel *)getResponseByRequset:(PIRPayModel *)request;

@end


#pragma mark - -------------------PIER_API_SEARCH_USER-------------------
#pragma mark - Request
@interface SearchUserRequest : PIRPayModel

@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *country_code;
@property(nonatomic, copy, readwrite) NSString *email;

@end

#pragma mark - Response
@interface SearchUserResponse : PIRPayModel

@property(nonatomic, copy, readonly) NSString *id;
@property(nonatomic, copy, readonly) NSString *first_name;
@property(nonatomic, copy, readonly) NSString *phone;
@property(nonatomic, copy, readonly) NSString *primary_email;
@property(nonatomic, copy, readonly) NSString *ssn;
@property(nonatomic, copy, readonly) NSString *last_name;
@property(nonatomic, copy, readonly) NSString *country_code;

@end

#pragma mark - -------------------PIER_API_HAS_CREDIT-------------------
#pragma mark - Request
@interface HasCreditRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readwrite) NSString *currency_code;
@end

#pragma mark - Response
@interface HasCreditResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *has_credit;
@end

#pragma mark - -------------------PIER_API_ADD_SUER-------------------
#pragma mark - Request
@interface AddUserRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *email;
@property(nonatomic, copy, readwrite) NSString *first_name;
@property(nonatomic, copy, readwrite) NSString *last_name;
@property(nonatomic, copy, readwrite) NSString *country_code;
@property(nonatomic, copy, readwrite) NSString *merchant_id;
@end

#pragma mark - Response
@interface AddUserResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *device_id;
@property(nonatomic, copy, readonly) NSString *user_id;
@property(nonatomic, copy, readonly) NSString *session_token;
@end

#pragma mark - -------------------PIER_API_ACTIVITE_DEVICE-------------------
#pragma mark - Request
@interface ActivityDeviceRequest : PIRPayModel @end

#pragma mark - Response
@interface ActivityDeviceResponse : PIRPayModel @end

#pragma mark - -------------------PIER_API_ADD_ADDRESS-------------------
#pragma mark - Request
@interface AddAddressRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readwrite) NSString *session_token;
@property(nonatomic, copy, readwrite) NSString *address;
@property(nonatomic, copy, readwrite) NSString *city;
@property(nonatomic, copy, readwrite) NSString *state_code;
@property(nonatomic, copy, readwrite) NSString *country_code;
@property(nonatomic, copy, readwrite) NSString *postal_code;
@property(nonatomic, copy, readwrite) NSString *is_primary;
@end

#pragma mark - Response
@protocol AddAddressModel @end
@interface AddAddressModel : PIRPayModel
@property(nonatomic, copy, readonly) NSString *address_id;//": "AD0000000066",
@property(nonatomic, copy, readonly) NSString *session_token;//": "73ed40ff-804e-11e4-8328-32913f86e6ed"
@end

@interface AddAddressResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSMutableArray<AddAddressModel> *items;
@end

#pragma mark - -------------------PIER_API_SET_PASSWORD-------------------
#pragma mark - Request
@interface SetPasswordRequest : PIRPayModel

@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readwrite) NSString *session_token;
@property(nonatomic, copy, readwrite) NSString *password;

@end

#pragma mark - Response

@interface SetPasswordResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString * session_token;
@end

#pragma mark - -------------------PIER_API_GET_AUTH_TOKEN-------------------
#pragma mark - Request

@interface GetAuthTokenReuest : PIRPayModel

@property(nonatomic, copy, readwrite) NSString *phone;//": "13621643896",
@property(nonatomic, copy, readwrite) NSString *country_code;//": "CN",
@property(nonatomic, copy, readwrite) NSString *password;//": "abc123",
@property(nonatomic, copy, readwrite) NSString *merchant_id;//": "MC0000000017",
@property(nonatomic, copy, readwrite) NSString *amount;//": "199.00",
@property(nonatomic, copy, readwrite) NSString *currency_code;//": "USD"

@end

#pragma mark - Response
@interface GetAuthTokenResponse : PIRPayModel

@property(nonatomic, copy, readonly) NSString *auth_token;

@end

#pragma mark - -------------------PIER_API_SAVE_DOB_SSN-------------------
#pragma mark - Request

@interface SaveDOBAndSSNRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *user_id;//
@property(nonatomic, copy, readwrite) NSString *session_token;//
@property(nonatomic, copy, readwrite) NSString *dob;//
@property(nonatomic, copy, readwrite) NSString *ssn;//
@end

#pragma mark - Response

@interface SaveDOBAndSSNResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *session_token;//
@end

#pragma mark - -------------------PIER_API_GET_AGREEMENT-------------------
#pragma mark - Request

@interface GetAgreementRequest : PIRPayModel

@end

#pragma mark - Response
@interface GetAgreementResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *url;
@end


#pragma mark - -------------------PIER_API_CREDIT_APPLICATION-------------------
#pragma mark - Request

@interface ApplicationApproveRequest : PIRPayModel
@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readwrite) NSString *session_token;
@property(nonatomic, copy, readwrite) NSString *device_token;
@property(nonatomic, copy, readwrite) NSString *currency_code;
@end

#pragma mark - Response
@interface ApplicationApproveResponse : PIRPayModel
@property(nonatomic, copy, readonly) NSString *currency;
@property(nonatomic, copy, readonly) NSString *category;
@property(nonatomic, copy, readonly) NSString *credit_limit;
@property(nonatomic, copy, readonly) NSString *shadow_limit;
@property(nonatomic, copy, readonly) NSString *note;
@property(nonatomic, copy, readonly) NSString *session_token;
@end
