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
@interface PierRequestTest : PierPayModel

@end

#pragma mark - Response
@interface PierResponseTest : PierPayModel

@end



