//
//  PierH5Utils.h
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PIRJSExecutedComplete)(NSString *result);

@interface PierH5Utils : NSObject


#pragma mark - --------------- URL -----------------

+ (NSDictionary *)parseURLQueryString:(NSString *)query;


#pragma mark - --------------- JavaScript -----------------

#pragma mark - Tools

/**
 * 获取Title
 */
+ (NSString *)getWebTitle:(UIWebView *)webView;

#pragma mark - Function
/**
 * 执行JS获取返回结果
 */
+ (NSString *)executeJS:(NSString *)js webView:(UIWebView *)webView;

/**
 * asychronized function.
 *
 * param: js: jave script.
 * param: func: JS Function.
 * param: param: (param1, param2...).
 * patam: complete: call back.
 */
+ (void)executeJS:(NSString *)js
             func:(NSString *)func
            param:(NSString *)param
          webView:(UIWebView *)webView
         conplete:(PIRJSExecutedComplete)complete;

@end
