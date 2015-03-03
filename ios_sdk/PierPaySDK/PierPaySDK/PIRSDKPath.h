//
//  PIRSDKPath.h
//  PierPaySDK
//
//  Created by zyma on 1/13/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#ifndef PierPaySDK_PIRSDKPath_h
#define PierPaySDK_PIRSDKPath_h

/** V1 */
NSString * const PIER_API_SEARCH_USER           = @"/user_api/v1/sdk/search_user";
NSString * const PIER_API_HAS_CREDIT            = @"/user_api/v1/sdk/has_credit";
NSString * const PIER_API_ADD_SUER              = @"/user_api/v1/sdk/add_user";
NSString * const PIER_API_ACTIVITE_DEVICE       = @"/user_api/v1/sdk/activate_device";
NSString * const PIER_API_ADD_ADDRESS           = @"/user_api/v1/sdk/add_address";
NSString * const PIER_API_SET_PASSWORD          = @"/user_api/v1/sdk/set_password";
NSString * const PIER_API_GET_AUTH_TOKEN        = @"/user_api/v1/sdk/get_auth_token";
NSString * const PIER_API_SAVE_DOB_SSN          = @"/user_api/v1/sdk/dob_ssn";
NSString * const PIER_API_GET_AGREEMENT         = @"/user_api/v1/sdk/get_agreement";
NSString * const PIER_API_CREDIT_APPLICATION    = @"/user_api/v1/sdk/application_approve";

/** V2 */
NSString * const PIER_API_TRANSACTION_SMS       = @"/user_api/v2/sdk/transaction_sms";
NSString * const PIER_API_GET_AUTH_TOKEN_V2     = @"/user_api/v2/sdk/get_auth_token";

NSString * const PIER_API_GET_ACTIVITY_CODE     = @"/user_api/v2/user/activation_code";
NSString * const PIER_API_GET_ACTIVITION        =  @"/user_api/v2/user/activation";

#endif
