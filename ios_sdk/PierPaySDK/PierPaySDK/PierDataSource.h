//
//  PIRDataSource.h
//  Pier
//
//  Created by Bei Wang  on 10/15/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PierConfig.h"
#import "PierPay.h"

@class PierDataSource;

extern PierDataSource *__dataSource;
void initDataSource();
void freeDataSource();


#define DATASOURCES_PHONE               @"phone"
#define DATASOURCES_COUNTRY_CODE        @"country_code"
#define DATASOURCES_MERCHANT_ID         @"merchant_id"
#define DATASOURCES_AMOUNT              @"amount"
#define DATASOURCES_CURRENCY            @"currency"
#define DATASOURCES_SERVER_URL          @"server_url"

extern NSString * const  pier_userdefaults_userinfo;
extern NSString * const  pier_userdefaults_phone;
extern NSString * const  pier_userdefaults_countrycode;
extern NSString * const  pier_userdefaults_password;

@interface PierDataSource : NSObject

/**
 * merchantParam
 * name:            Required     Type       Description
 * 1.phone           YES          NSString   user phone.
 * 2.country_code    YES          NSString   the country code of user phone.
 * 3.merchant_id     YES          NSString   your id in pier.
 * 4.amount          YES          NSString   amount.
 * 5.currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 * 6.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 */
@property (nonatomic, strong) NSDictionary *merchantParam;
@property (nonatomic, copy) NSString *session_token;        // session token
@property (nonatomic, copy) NSString *device_id;            // device id
@property (nonatomic, copy) NSString *user_id;              // user id
@property (nonatomic, assign) BOOL hasCredit;               // 判断用户是否有credit
@property (nonatomic, weak) id<PayByPierDelegate> pierDelegate;

/**
 * userInfo
 * name:            Required     Type       Description
 * 1.phone           YES          NSString   user phone.
 * 2.country_code    YES          NSString   the country code of user phone.
 * 3.passwoed
 */
- (void)saveUserInfo:(NSDictionary *)userInfo;
- (NSDictionary *)getUserInfo;
- (NSString *)getPassword:(NSDictionary *)userInfo;
- (void)clearUserInfo;

@end