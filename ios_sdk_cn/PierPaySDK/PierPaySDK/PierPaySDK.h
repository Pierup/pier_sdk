//
//  PierPaySDK.h
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PayWithPierComplete)(NSDictionary *result, NSError *error);

@interface PierPaySDK : NSObject

/**
 * Pier支付接口
 * 
 * @param charge        订单信息
 *
 *   Key             Required     Type       Description
 * - merchant_id     YES          NSString   your id in pier.
 * - api_id          YES          NSString   amount.
 * - amount          YES          NSString   tThe code of currency,such as 'USD','RMB' and so on.The default value is 'USD'.
 * - charset         YES          NSString   merchant orderID
 * - order_id        NO           NSString   merchant name
 * - order_detail    NO           NSString   订单详情
 *
 *
 * @param delegate      商户当前页面
 *
 * @param fromScheme    调用品而支付的商户app注册在info.plist中的scheme
 *
 * @param completion
 */
- (void)createPayment:(NSDictionary *)charge
             delegate:(id)delegate
           fromScheme:(NSString *)fromScheme
           completion:(PayWithPierComplete)completion;

@end
