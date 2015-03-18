//
//  PIRURLDispatcher.m
//  PierPayDemo
//
//  Created by zyma on 3/18/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PIRURLDispatcher.h"
#import "JSONKit.h"
#import "ShopListViewController.h"
#import "ProductViewController.h"

static PIRURLDispatcher * __instance;

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
 * userAttributes
 * name:            Required     Type       Description
 * 1.phone           YES          NSString   user phone.
 * 2.country_code    YES          NSString   the country code of user phone.
 * 3.merchant_id     YES          NSString   your id in pier.
 */
- (void)dispatchURL:(NSURL *)url{
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dicQuery = [PIRURLDispatcher parseURLQueryString:query];
    NSString *phone = [dicQuery objectForKey:@"phone"];
    NSString *country_code = [dicQuery objectForKey:@"country_code"];
    NSString *merchant_id = [dicQuery objectForKey:@"merchant_id"];
    MerchantModel *merchantModel = [[MerchantModel alloc] init];
    merchantModel.phone = phone;
    merchantModel.country_code = country_code;
    merchantModel.merchant_id = merchant_id;
    if (merchantModel.merchant_id!=nil && merchantModel.merchant_id.length>0) {
        ProductViewController *productViewController = [[ProductViewController alloc]init];
        productViewController.merchantModel = merchantModel;
        [self.mainNavigationController pushViewController:productViewController animated:NO];
    }
}

+ (void)parseURL:(NSURL *)url{
    
}

+ (NSDictionary *)parseURLQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for(NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        if([keyValue count] == 2) {
            NSString *key = [keyValue objectAtIndex:0];
            NSString *value = [keyValue objectAtIndex:1];
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if(key && value)
                [dict setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
