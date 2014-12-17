//
//  PIRPayModel.m
//  PierPaySDK
//
//  Created by zyma on 12/17/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PIRPayModel.h"

@implementation PIRPayModel

- (PIRPayModel *)getResponseByRequset:(PIRPayModel *)request{
    /** child class @implementation */
    return nil;
}

@end

/**
 *  API  : /user_api/v1/sdk/search_user
 */
@implementation SearchUserRequest @end

@interface SearchUserResponse ()
@property(nonatomic, copy, readwrite) NSString *id;
@property(nonatomic, copy, readwrite) NSString *first_name;
@property(nonatomic, copy, readwrite) NSString *phone;
@property(nonatomic, copy, readwrite) NSString *primary_email;
@property(nonatomic, copy, readwrite) NSString *ssn;
@property(nonatomic, copy, readwrite) NSString *last_name;
@property(nonatomic, copy, readwrite) NSString *country_code;
@end

@implementation SearchUserResponse

- (PIRPayModel *)getResponseByRequset:(PIRPayModel *)request{
    PIRPayModel *response = [[PIRPayModel alloc] init];
    
    return response;
}

@end

