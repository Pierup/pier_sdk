//
//  PierPaySDK.h
//  PierPaySDK
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PierPayDelegate <NSObject>

@required

/**
 * Result
 * name:        Type            Description
 * 1.status     NSNumber        Showing the status of sdk execution.It means successful if is '0',else means '1'.
 * 2.message    NSString        Showing the message from pier.
 * 3.code       NSNumber        Showing the code of message from pier.
 * 4.result     NSDictionary    Showing the value of output params of pier.
 * 5.spending   NSString        spending.
 */
-(void)payWithPierComplete:(NSDictionary *)result;

@end

#pragma mark - navigationController
@interface PierPay : UINavigationController

@property (nonatomic, weak) id<PierPayDelegate> pierDelegate;

/**
 * pay by pier with password
 * userAttributes
 * name:            Required     Type       Description
 * 1.phone           YES          NSString   user phone.
 * 2.country_code    YES          NSString   the country code of user phone.
 * 3.merchant_id     YES          NSString   your id in pier.
 * 4.amount          YES          NSString   amount.
 * 5.currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 * 6.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 */
- (instancetype)initWith:(NSDictionary *)userAttributes delegate:(id)delegate;


/**
 * pay by pier without password
 * name:            Required     Type       Description
 * 1.phone           YES          NSString   user phone.
 * 2.merchant_id     YES          NSString   your id in pier.
 * 3.amount          YES          NSString   amount.
 * 4.currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 * 5.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 * 6.session_token   YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 */
+ (void)payWith:(NSDictionary *)userAttributes delegate:(id)delegate;

@end