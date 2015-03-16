//
//  PIRDataSource.h
//  Pier
//
//  Created by Bei Wang  on 10/15/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIRConfig.h"
#import "PierPay.h"

@class PIRDataSource;

extern PIRDataSource *__dataSource;
void initDataSource();
void freeDataSource();

@interface PIRDataSource : NSObject


@property (nonatomic, strong) NSDictionary *merchantParam;
@property (nonatomic, copy) NSString *country_code;         // 国家码
@property (nonatomic, copy) NSString *session_token;        // session token
@property (nonatomic, copy) NSString *device_id;            // device id
@property (nonatomic, copy) NSString *user_id;              // user id
@property (nonatomic, assign) BOOL hasCredit;               // 判断用户是否有credit
@property (nonatomic, copy) NSString *phone;                // phone
@property (nonatomic, weak) id<PayByPierDelegate> pierDelegate;

@end