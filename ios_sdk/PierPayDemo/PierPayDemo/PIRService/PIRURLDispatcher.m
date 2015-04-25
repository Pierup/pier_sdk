//
//  PIRURLDispatcher.m
//  PierPayDemo
//
//  Created by zyma on 3/18/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PIRURLDispatcher.h"
#import "JSONKit.h"
#import "ProductViewController.h"
#import "PierPay.h"

static PIRURLDispatcher * __instance;

@interface PIRURLDispatcher ()

@end

@implementation PIRURLDispatcher

+ (PIRURLDispatcher *)shareInstance{
    if (__instance == nil) {
        @synchronized(self){
            if (__instance == nil) {
                __instance = [[PIRURLDispatcher alloc] init];
            }
        }
    }
    return __instance;
}

/**
 * charge
 * name:            Required     Type       Description
 * 1.phone           YES          NSString   user phone.
 * 2.country_code    YES          NSString   the country code of user phone.
 * 3.merchant_id     YES          NSString   your id in pier.
 */
- (void)dispatchURL:(NSURL *)url{
    [PierPay handleOpenURL:url completion:^(NSDictionary *result, NSError *error) {
        NSDictionary * dicQuery = result;
        NSString *phone = [dicQuery objectForKey:@"phone"];
        NSString *country_code = [dicQuery objectForKey:@"country_code"];
        NSString *merchant_id = [dicQuery objectForKey:@"merchant_id"];
        NSString *shop_name = [dicQuery objectForKey:@"shop_name"];
        /**
         * status：
         * App中支付完成 App->Merchant:   1 payment success；2 payment failed
         * SDK创建支付后 App->Merchant:   3 open merchant product
         */
        NSInteger status = [[dicQuery objectForKey:@"status"] integerValue];
        
        MerchantModel *merchantModel = [[MerchantModel alloc] init];
        merchantModel.phone = phone;
        merchantModel.country_code = country_code;
        merchantModel.merchant_id = merchant_id;
        merchantModel.business_name = shop_name;

        if (status == 3) {
            if (merchantModel.merchant_id!=nil && merchantModel.merchant_id.length>0) {
                ProductViewController *productViewController = [[ProductViewController alloc]init];
                productViewController.merchantModel = merchantModel;
                [self.mainNavigationController pushViewController:productViewController animated:NO];
                
#pragma mark - --------------------- Test ---------------------
//                NSString *session_token = [dicQuery objectForKey:@"session_token"];
//                if (session_token != nil && session_token.length > 0) {
//                    NSMutableDictionary *dic_dicQuery = [NSMutableDictionary dictionaryWithDictionary:dicQuery];
////                    [dic_dicQuery setValue:@"http://192.168.1.254:8080/pier-merchant/server/sdk/pay/AAA000000001" forKey:@"server_url"];
//                    [dic_dicQuery setValue:@"http://piertest-env.elasticbeanstalk.com/server/sdk/pay/AAA000000001" forKey:@"server_url"];
//                    [dic_dicQuery setValue:@"65.59" forKey:@"amount"];
//                    [dic_dicQuery setValue:@"USD" forKey:@"currency"];
//                    [dic_dicQuery setValue:@"Test Shop" forKey:@"shop_name"];
//                    [dic_dicQuery setValue:[self getRandomNumber:1000000000 to:10000000000] forKey:@"order_id"];
//                    NSString *testDeviceToken = [[dic_dicQuery objectForKey:@"device_token"] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
//                    [dic_dicQuery setValue:testDeviceToken forKey:@"device_token"];
//                    [PierPay payWith:dic_dicQuery delegate:self];
//                }
#pragma mark - --------------------- Test ---------------------
            }
        }else{
            if (status == 1) {//payment success
                NSString *amount = [dicQuery objectForKey:@"amount"];
                UIAlertView *callBackAlert = [[UIAlertView alloc] initWithTitle:@"Payment Success" message:[NSString stringWithFormat:@"Amoubt:%@",amount] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [callBackAlert show];
            }else if (status == 2){//payment failed
                UIAlertView *callBackAlert = [[UIAlertView alloc] initWithTitle:@"Payment Failed" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [callBackAlert show];
            }
        }
    }];
}

#pragma mark - ------------------ PierPayDelegate -------------

//-(void)payWithPierComplete:(NSDictionary *)result{
//    NSInteger status = [[result objectForKey:@"status"] integerValue];
//    if (status == 2) {
//        //failed
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pay With Pier Failed." message:[NSString stringWithFormat:@"%@",[result objectForKey:@"message"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }else if (status == 1){
//        //success
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pay With Pier Success." message:[NSString stringWithFormat:@"Total Amount:%@",[result objectForKey:@"amount"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//}

//+ (void)parseURL:(NSURL *)url{
//    
//}

-(NSString *)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    NSInteger randomInt = (NSInteger)(from+(arc4random() % (to-from+1)));//+1,result is [from to]; else is [from, to)
    return [NSString stringWithFormat:@"%ld",randomInt];
}



@end
