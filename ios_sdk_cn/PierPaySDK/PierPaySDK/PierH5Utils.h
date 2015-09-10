//
//  PierH5Utils.h
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ePierPageID_login                   = 200001, //登录页面
    ePierPageID_confirm                 = 200002, //订单确认页面（confirm）
    ePierPageID_regist                  = 200003, //支付页面（payment）
    ePierPageID_pay_success             = 200004, //支付成功
    ePierPageID_pay_fialed              = 200005, //支付失败
    ePierPageID_error                   = 200006, //发生错误
} ePierPageID;

typedef void(^PIRJSExecutedComplete)(NSString *result);


@interface PierWebInfoModel : NSObject

@property (nonatomic, assign) ePierPageID paye_id;

@end

@interface PierH5Utils : NSObject


#pragma mark - --------------- URL -----------------

+ (NSDictionary *)parseURLQueryString:(NSString *)query;

+ (NSString *)getURLQurey:(NSDictionary *)dic;


#pragma mark - --------------- JavaScript -----------------

#pragma mark - Tools

/**
 * 获取Title
 */
+ (NSString *)getWebTitle:(UIWebView *)webView;

/** 
 * 获取页面信息
 */
+ (PierWebInfoModel *)getPageInfo:(UIWebView *)webView;

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
