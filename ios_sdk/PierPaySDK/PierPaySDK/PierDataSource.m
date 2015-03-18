//
//  PIRDataSource.m
//  Pier
//
//  Created by Bei Wang on 10/15/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import "PierDataSource.h"
#import "NSString+Check.h"

PierDataSource *__dataSource;

void initDataSource()
{
    if (__dataSource == nil) {
        __dataSource = [[PierDataSource alloc] init];
    }
}

void freeDataSource()
{
    __dataSource = nil;
}

@interface PierDataSource ()

@end

@implementation PierDataSource

#pragma mark - PIRDataSource init & dealloc
- (id)init
{
    self = [super init];
    if (self) {
        self.session_token = @"";
        self.device_id = @"";
        self.user_id = @"";
        self.country_code = @"US";
    }
    
    return self;
}


- (void)setCountry_code:(NSString *)country_code{
    if (![NSString emptyOrNull:country_code]) {
        _country_code = country_code;
    }
}

- (void)setSession_token:(NSString *)sessionToken{
    if (![NSString emptyOrNull:sessionToken]) {
        _session_token = sessionToken;
    }
}

- (void)setUser_id:(NSString *)user_id{
    if (![NSString emptyOrNull:user_id]) {
        _user_id = user_id;
    }
}

- (void)setPhone:(NSString *)phone{
    if (![NSString emptyOrNull:phone]) {
        _phone = phone;
    }
}

@end
