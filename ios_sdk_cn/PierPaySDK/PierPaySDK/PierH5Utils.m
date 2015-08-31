//
//  PierH5Utils.m
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PierH5Utils.h"

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
