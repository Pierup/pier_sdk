//
//  PierURLDispatcher.h
//  PierPaySDK
//
//  Created by zyma on 9/9/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PierWebActionModel;

typedef enum : NSUInteger {
    ePierAction_login                   = 10001, //登录事件
    ePierAction_pay                     = 10002, //支付事件
    ePierAction_return                  = 10003, //支付完成
    ePierAction_login_to_confirm        = 10004, //登录成功进入confirm
    ePierAction_login_to_regist         = 10005, //登陆成功进入注册流程
    ePierAction_login_to_pay            = 10008, //登录成功进入支付页面
    ePierAction_regist                  = 10009, //sdk进入注册
    ePierAction_forgot_password         = 10010, //sdk忘记密码
    ePierAction_forgot_pin              = 10011, //sdk忘记支付密码
    ePierAction_set_password            = 10012, //设置密码
    ePierAction_set_password_success    = 10013, //设置密码成功
    ePierAction_error                   = 10014, //发生错误
    ePierAction_apply_credit            = 10015, //申请信用（注册流程）
    ePierAction_apply_credit_success    = 10016, //申请信用成功（注册流程）
    ePierAction_apply_credit_failed     = 10017  //申请信用失败（注册流程）
} ePierAction;



@protocol PierURLDispatcherDeleagte <NSObject>

- (void)dispatcheFinish:(PierWebActionModel *)model;

@end

// action model
@interface PierWebActionModel : NSObject

@property (nonatomic, assign) ePierAction action_type;
@property (nonatomic, strong) NSDictionary *result;

@end



@interface PierURLDispatcher : NSObject

@property (nonatomic, weak) id<PierURLDispatcherDeleagte> delegate;

//+ (PierURLDispatcher *)shareInstance;

//根据第三方传来的url跳转到相应页面
- (BOOL)dispatchURL:(NSURL *)url viewController:(UIViewController *)viewController;

@end
