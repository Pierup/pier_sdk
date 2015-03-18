//
//  PIRDataSource.m
//  Pier
//
//  Created by Bei Wang on 10/15/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import "PierDataSource.h"
#import "NSString+PierCheck.h"

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
    }
    
    return self;
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

@end
