//
//  PIRPayModel.m
//  PierPaySDK
//
//  Created by zyma on 12/17/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PIRPayModel1.h"

@implementation PIRPayModel1

- (PIRPayModel1 *)getResponseByRequset:(PIRPayModel1 *)request{
    /** child class @implementation */
    return nil;
}

@end

/**
 *  API  : /user_api/v1/sdk/search_user
 */
@implementation SearchUserRequest @end

@interface SearchUserResponseModel ()
@property(nonatomic, copy, readwrite) NSString *id;
@property(nonatomic, copy, readwrite) NSString *first_name;
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *primary_email;
@property(nonatomic, copy, readwrite) NSString *ssn;
@property(nonatomic, copy, readwrite) NSString *last_name;
@property(nonatomic, copy, readwrite) NSString *country_code;
@end

@implementation SearchUserResponseModel

@end

@interface SearchUserResponse ()

@end

@implementation SearchUserResponse

- (PIRPayModel1 *)getResponseByRequset:(PIRPayModel1 *)request{
    PIRPayModel1 *response = [[PIRPayModel1 alloc] init];
    
    return response;
}

@end


@implementation HasCreditRequest

@end

@interface HasCreditResponse ()
@property(nonatomic, copy, readwrite) NSString *has_credit;
@end

@implementation HasCreditResponse

@end

@implementation AddUserRequest

@end

@interface AddUserResponse ()
@property(nonatomic, copy, readwrite) NSString *device_id;
@property(nonatomic, copy, readwrite) NSString *user_id;
@property(nonatomic, copy, readwrite) NSString *session_token;
@end

@implementation AddUserResponse

@end

#pragma mark - Request
@implementation ActivityDeviceRequest

@end

#pragma mark - Response
@implementation ActivityDeviceResponse

@end

#pragma mark - Request
@implementation AddAddressRequest

@end

@implementation AddAddressModel

@end

#pragma mark - Response
@implementation AddAddressResponse

@end

@interface SetPasswordRequest ()

@end

@implementation SetPasswordRequest

@end


@interface SetPasswordResponse ()
@property(nonatomic, copy, readwrite) NSString * session_token;
@end

@implementation SetPasswordResponse

@end

@interface GetAuthTokenReuest ()

@end

@implementation GetAuthTokenReuest

@end

@interface GetAuthTokenResponse ()
@property(nonatomic, copy, readwrite) NSString *auth_token;
@end

@implementation GetAuthTokenResponse

@end


@interface SaveDOBAndSSNRequest ()

@end

@implementation SaveDOBAndSSNRequest

@end

@interface SaveDOBAndSSNResponse ()
@property(nonatomic, copy, readwrite) NSString *session_token;
@end

@implementation SaveDOBAndSSNResponse

@end

@implementation GetAgreementRequest

@end

@interface GetAgreementResponse ()
@property(nonatomic, copy, readwrite) NSString *url;
@end

@implementation GetAgreementResponse

@end

@interface ApplicationApproveRequest ()

@end

@implementation ApplicationApproveRequest

@end

@interface ApplicationApproveResponse ()
@property(nonatomic, copy, readwrite) NSString *currency;
@property(nonatomic, copy, readwrite) NSString *category;
@property(nonatomic, copy, readwrite) NSString *credit_limit;
@property(nonatomic, copy, readwrite) NSString *shadow_limit;
@property(nonatomic, copy, readwrite) NSString *note;
@property(nonatomic, copy, readwrite) NSString *session_token;
@end

@implementation ApplicationApproveResponse

@end