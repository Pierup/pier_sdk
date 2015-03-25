//
//  PierPaySDK.h
//  PierPaySDK
//
//  Created by Pier  on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PierPayDelegate <NSObject>

@required

/**
 * Call Back When Pay With Pier In Merchant App.
 * Result
 * name:        Type            Description
 * 1.status     NSNumber        Showing the status of sdk execution.It means successful if is '0', else is '1'.
 * 2.message    NSString        Showing the message from pier.
 * 3.code       NSNumber        Showing the code of message from pier.
 * 4.result     NSDictionary    Showing the value of output params of pier.
 * 5.spending   NSString        spending.
 * 6.order_id   NSString        merchant orderID
 * 7.shop_name  NSString        merchant name
 *
 */
-(void)payWithPierComplete:(NSDictionary *)result;

@end

/**
 * Call Back When Pay With Pier In Pier App.
 * Result
 * name:        Type            Description
 * 1.status     NSNumber        Showing the status of sdk execution.It means successful if is '0', else is '1'.
 * 2.message    NSString        Showing the message from pier.
 * 3.code       NSNumber        Showing the code of message from pier.
 * 4.result     NSDictionary    Showing the value of output params of pier.
 * 5.spending   NSString        spending.
 * 6.order_id   NSString   merchant orderID
 * 7.shop_name  NSString        merchant name
 *
 */
typedef void (^payWithPierComplete)(NSDictionary *result, NSError *error);

#pragma mark - navigationController
@interface PierPay : UINavigationController

@property (nonatomic, weak) id<PierPayDelegate> pierDelegate;

/**
 * pay by pier with password
 * charge
 * name:            Required     Type       Description
 * 1.phone           NO           NSString   user phone.
 * 2.country_code    NO           NSString   the country code of user phone.
 * 3.merchant_id     YES          NSString   your id in pier.
 * 4.amount          YES          NSString   amount.
 * 5.currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 * 6.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 * 7.order_id        YES          NSString   merchant orderID
 * 8.shop_name       NO           NSString   merchant name
 *
 */
- (instancetype)initWith:(NSDictionary *)charge delegate:(id)delegate;

/**
 *  charge
 *  name:            Required     Type       Description
 *  1.amount          YES          NSString   amount.
 *  2.currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 *  3.merchant_id     YES          NSString   your id in pier.
 *  4.scheme          YES          NSString   merchant App scheme
 *  5.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 *  6.shop_name       NO           NSString   merchant name
 *
 */
+ (void)createPayment:(NSDictionary *)charge;

/**
 *  Call Back Pier Payent result
 *
 *  @param url              
 *  @param CallBack
 */
+ (void)handleOpenURL:(NSURL *)url withCompletion:(payWithPierComplete)completion;

/**
 * Pier App 内部支付使用，Merchant App用不到。打包时候注释掉这个方法。
 * pay by pier without password
 * name:            Required     Type       Description
 * 1.phone           NO          NSString   user phone.
 * 2.merchant_id     NO          NSString   your id in pier.
 * 3.amount          YES          NSString   amount.
 * 4.currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 * 5.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 * 6.session_token   YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 * 7.order_id        YES          NSString   merchant orderID
 * 8.shop_name       NO           NSString   merchant name
 *
 */
+ (void)payWith:(NSDictionary *)charge delegate:(id)delegate;

@end