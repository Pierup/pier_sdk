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
 *
 *  @abstract Call Back When Pay With Pier In Merchant App.
 *
 *  @param result
 *    key        Type            Description
 *  - status     NSNumber        Showing the status of sdk execution.It means successful if is '0', else is '1'.
 *  - message    NSString        Showing the message from pier.
 *  - code       NSNumber        Showing the code of message from pier.
 *  - result     NSDictionary    Showing the value of output params of pier.
 *  - spending   NSString        spending.
 *  - order_id   NSString        merchant orderID
 *  - shop_name  NSString        merchant name
 *
 */
-(void)payWithPierComplete:(NSDictionary *)result;

@end

/**
 * @abstract Call Back When Pay With Pier In Pier App.
 *
 * @param result
 *   Key        Type            Description
 * - status     NSNumber        Showing the status of sdk execution.It means successful if is '0', else is '1'.
 * - message    NSString        Showing the message from pier.
 * - code       NSNumber        Showing the code of message from pier.
 * - result     NSDictionary    Showing the value of output params of pier.
 * - spending   NSString        spending.
 * - order_id   NSString   merchant orderID
 * - shop_name  NSString        merchant name
 *
 * @param error
 *
 */
typedef void (^payWithPierComplete)(NSDictionary *result, NSError *error);

#pragma mark - navigationController
@interface PierPay : UINavigationController

@property (nonatomic, weak) id<PierPayDelegate> pierDelegate;

/**
 * @abstract pay by pier with password
 *
 * @param charge
 *   Key             Required     Type       Description
 * - phone           NO           NSString   user phone.
 * - country_code    NO           NSString   the country code of user phone.
 * - merchant_id     YES          NSString   your id in pier.
 * - amount          YES          NSString   amount.
 * - currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 * - server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 * - order_id        YES          NSString   merchant orderID
 * - shop_name       NO           NSString   merchant name
 *
 * @param delegate self
 *
 */
- (instancetype)initWith:(NSDictionary *)charge delegate:(id)delegate;

/**
 *  @abstract pay by pier with password
 *
 *  @param charge
 *    key             Required     Type       Description
 *  - amount          YES          NSString   amount.
 *  - currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 *  - merchant_id     YES          NSString   your id in pier.
 *  - scheme          YES          NSString   merchant App scheme
 *  - server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 *  - shop_name       YES          NSString   merchant name
 *
 */
+ (void)createPayment:(NSDictionary *)charge;

/**
 *  Call Back Pier Payment result
 *
 *  @param url              
 *  @param CallBack
 *
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
 * 9.device_token    NO           NSString   Device_Token
 *
 */
+ (void)payWith:(NSDictionary *)charge delegate:(id)delegate;

@end