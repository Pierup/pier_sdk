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
        self.hasPwd = NO;
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

- (void)clearUserPassword{
    __pierDataSource.hasPwd = NO;
    NSMutableDictionary *userInfo = [[self getUserInfo] mutableCopy];
    [userInfo setValue:@"" forKey:pier_userdefaults_password];
    [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:pier_userdefaults_userinfo];
}

/**
 * @abstract Call Back When Pay With Pier In Pier App.
 *
 * @param result
 *   Key        Type            Description
 * - status     NSNumber        Showing the status of sdk execution.It means successful if is '1', else is '2'.
 * - message    NSString        Showing the message from pier.
 * - amount     NSString        amount.
 * - currency   NSString        NSString
 * - result     NSDictionary    Showing the value of output params of pier (This parameter is extended).
 *
 * @param error
 *
 */
- (NSDictionary *)getCallBackDic:(NSDictionary *)result{
    NSDictionary *callBack = nil;
    callBack = [NSDictionary dictionaryWithObjectsAndKeys:
                [result objectForKey:@"status"], @"status",
                [NSString getUnNilString:[result objectForKey:@"message"]], @"message",
                [NSString getUnNilString:[result objectForKey:@"amount"]], @"amount",
                [NSString getUnNilString:[__pierDataSource.merchantParam objectForKey:DATASOURCES_CURRENCY]], @"currency",
                [NSDictionary dictionary], @"result",nil];
    return callBack;
}

@end
