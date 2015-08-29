//
//  PierPaySDK.h
//  PierPaySDK
//
//  Created by Pier  on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
typedef void (^payWithPierComplete)(NSDictionary *result, NSError *error);
typedef void (^payWithPier)();

#pragma mark - navigationController
@interface PierPay : UINavigationController

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
- (void)createPayment:(NSDictionary *)charge
                  pay:(payWithPier)pay
           completion:(payWithPierComplete)completion;

/**
 *  @abstract pay by pier in Pier App. It will navigate to Pier App.
 *
 *  @param charge
 *    key             Required     Type       Description
 *  - amount          YES          NSString   amount.
 *  - currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 *  - merchant_id     YES          NSString   your id in pier.
 *  - scheme          YES          NSString   merchant App scheme
 *  - server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 *  - order_id        YES          NSString   merchant orderID
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
+ (void)handleOpenURL:(NSURL *)url completion:(payWithPierComplete)completion;


#pragma mark - ---------- Only used in PierApp ----------

/**
 * Pier App Only used in PierApp. 打包时候注释掉这个方法。
 *
 * pay by pier without password
 * name:            Required     Type       Description
 * 1.phone           NO          NSString   user phone.
 * 2.merchant_id     NO          NSString   your id in pier.
 * 3.amount          YES          NSString   amount.
 * 4.currency        YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 * 5.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 * 6.session_token   YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
 * 7.order_id        YES          NSString   merchant orderID
 * 8.shop_name       YES           NSString   merchant name
 * 9.device_token    NO           NSString   Device_Token
 *
 */
+ (void)payWith:(NSDictionary *)charge delegate:(id)delegate completion:(payWithPierComplete)completion;

@end