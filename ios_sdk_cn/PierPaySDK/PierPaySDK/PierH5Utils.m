//
//  PierH5Utils.m
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PierH5Utils.h"
#import "PierJSONKit.h"

@implementation PierWebInfoModel


@end

@implementation PierH5Utils

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

+ (NSString *)getURLQurey:(NSDictionary *)dic{
    
    NSMutableString *paramString = [NSMutableString stringWithString:@""];
    NSArray *keys = [dic allKeys];
    for (NSString *key in keys)
    {
        if ([dic[key] length] != 0)
        {
            [paramString appendFormat:@"&%@=%@", key, dic[key]];
        }
    }
    
    if ([paramString length] > 1)
    {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];    // remove first '&'
    }
    
    return paramString;
}

/**
 * 获取页面信息
 */
+ (PierWebInfoModel *)getPageInfo:(UIWebView *)webView{
    NSString *result = [PierH5Utils executeJS:@"getPageInfo()" webView:webView];
    NSDictionary *result_dic = [result objectFromJSONString];
    PierWebInfoModel *model = [[PierWebInfoModel alloc] init];
    model.paye_id = [[result_dic objectForKey:@"page_id"] integerValue];
    return model;
}

+ (NSString *)getWebTitle:(UIWebView *)webView{
    NSString *result = @"";
    result = [self executeJS:@"document.title" webView:webView];
    return result;
}

+ (NSString *)executeJS:(NSString *)js webView:(UIWebView *)webView{
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:js];
    return result;
}

+ (void)executeJS:(NSString *)js
             func:(NSString *)func
            param:(NSString *)param
          webView:(UIWebView *)webView
         conplete:(PIRJSExecutedComplete)complete{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *jsfunc = [NSString stringWithFormat:@"%@(%@)",func, param];
        NSString *result = [webView stringByEvaluatingJavaScriptFromString:[js stringByAppendingString:jsfunc]];
        complete(result);
    });
}


@end
