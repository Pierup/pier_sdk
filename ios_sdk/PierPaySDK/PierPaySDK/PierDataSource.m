//
//  PierDataSource.m
//  Pier
//
//  Created by Bei Wang on 10/15/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import "PierDataSource.h"
#import "NSString+PierCheck.h"

NSString * const  pier_userdefaults_userinfo    = @"pier_pay_user_info";
NSString * const  pier_userdefaults_phone       = @"pier_pay_user_phone";
NSString * const  pier_userdefaults_countrycode = @"pier_pay_user_country_code";
NSString * const  pier_userdefaults_password    = @"pier_pay_user_password";

PierDataSource *__pierDataSource;

void pierInitDataSource()
{
    if (__pierDataSource == nil) {
        __pierDataSource = [[PierDataSource alloc] init];
    }
}

void pierFreeDataSource()
{
    __pierDataSource = nil;
}

@interface PierDataSource ()

@end

@implementation PierDataSource

#pragma mark - PierDataSource init & dealloc
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

- (void)saveUserInfo:(NSDictionary *)userInfo{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:userInfo forKey:pier_userdefaults_userinfo];
}

- (NSDictionary *)getUserInfo{
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:pier_userdefaults_userinfo];
    return userinfo;
}

- (NSString *)getPhone{
    NSDictionary *userDic = [self getUserInfo];
    NSString *phone = [userDic objectForKey:pier_userdefaults_phone];
    return phone;
}

- (NSString *)getCountryCode{
    NSDictionary *userDic = [self getUserInfo];
    NSString *countryCode = [userDic objectForKey:pier_userdefaults_countrycode];
    return countryCode;
}

- (NSString *)getPassword{
    NSDictionary *userDic = [self getUserInfo];
    NSString *password = [userDic objectForKey:pier_userdefaults_password];
    return password;
}

- (NSString *)getPassword:(NSDictionary *)userInfo{
    NSString *pwd = @"";
    NSDictionary *info = [self getUserInfo];
    if ([[info objectForKey:pier_userdefaults_phone] isEqualToString:[userInfo objectForKey:pier_userdefaults_phone]] &&
        [[info objectForKey:pier_userdefaults_countrycode] isEqualToString:[userInfo objectForKey:pier_userdefaults_countrycode]]) {
        pwd = [info objectForKey:pier_userdefaults_password];
    }
    return pwd;
}

- (void)clearUserInfo{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"", pier_userdefaults_phone,
                         @"", pier_userdefaults_countrycode,
                         @"", pier_userdefaults_password,nil];
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:pier_userdefaults_userinfo];
}

@end
