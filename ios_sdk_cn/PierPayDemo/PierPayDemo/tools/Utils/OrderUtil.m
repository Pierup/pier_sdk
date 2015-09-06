//
//  OrderUtil.m
//  PierPayDemo
//
//  Created by zyma on 9/6/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "OrderUtil.h"
#import "RSADigitalSignature.h"

/**********************商户注册时候获取的私钥**************************/

static const NSString * PRIVATE_KEY =
@"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAPbRrFFeG9ViAwYk"
"BdeWel4BIVP3JjpQDjTBN3c63SWEa64J+iXGX/8/d3x6D9aVIiLzbwQ5afJ4DA4V"
"wLjiIl09a9xs/X8F0BEWUxKoVXrARGVs1mB5HllnTzEXTOVEn+HjoQURNAuWqBGV"
"INjmsLpJl8aMq5fbpSBzxzQC4x3vAgMBAAECgYBzQf6CELxWrOpUl8XSowaJl2WE"
"3EkRugioQgIwv2A+ANR39VjHAxgZDf4yNp3mysWiJKOXCWicPcsDWM0iiRcaIKwt"
"T4t3fvZ8DR6SFKht5JkjxJYMCwlFVeS2OQ+KOVcXlhWXjUO1V+3N/eXqiGGVeBl9"
"mPADcqP4wgzT2SDzYQJBAPtkGNp4peMsv27siVh6JRwxbgAf55Homlisygw7h9Yi"
"lJ/5XJABt7Lag2sk1rixY/oH3vhH7g0b4mSdJhEPqaUCQQD7WB4VRdoEtVyqW0Rk"
"NnUVnGHhAOGfdh6f/+NMMvbnXkblqCV8c5XxOjdfQMO5hfair0aNJgcA1LLzUAPs"
"f80DAkEApE0ylS8/NG/dmhDMX2BNetSvkTNI9SryHbyovT/3MrQdMUUYAyKsPh/k"
"vpUwJTwDHLoiN2FDq5uq5ply9Lmo5QJAd5xTlKQNQLheROPyBA62YXZuTflxZcV8"
"hX/s11JZlXmUG66NSFBpRscBmt7jReKuoHTxCjLSml6eWpP1ihK3qQJBALvInreQ"
"dfTIAZS2oYYoE340ohHLbow4+uEOXnSkD2m95MqNg4ghda6fwAS7O+lIt5vEB4nV"
"X/nCZkNpHjMXDPo=";

/******************************************************************/

@implementation OrderUtil

+ (NSString *)getSgin:(NSDictionary *)charge{
    // 所有参与订单签名的字段，这些字段以外不参与签名
    NSArray *keyArray = @[@"merchant_id",
                          @"amount",
                          @"charset",
                          @"api_id",
                          @"api_secret_key",
                          @"order_id",
                          @"return_url"];
    
    // 对字段进行字母序排序
    NSMutableArray *sortedKeyArray = [NSMutableArray arrayWithArray:keyArray];
    
    [sortedKeyArray sortUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableString *paramString = [NSMutableString stringWithString:@""];
    
    for (NSString *key in sortedKeyArray)
    {
        if ([charge[key] length] != 0)
        {
            [paramString appendFormat:@"&%@=%@", key, charge[key]];
        }
    }
    
    if ([paramString length] > 1)
    {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];    // remove first '&'
    }
    
    NSString *private_key = [PRIVATE_KEY copy];
    
    NSString *sign = [RSADigitalSignature createSignature:paramString privateKey:private_key];
    return sign;
}

@end
