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


#pragma mark - -------------------search User-------------------
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