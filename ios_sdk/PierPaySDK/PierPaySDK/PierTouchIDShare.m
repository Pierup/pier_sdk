//
//  PIRTouchIDController.m
//  Pier
//
//  Created by zyma on 11/17/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import "PierTouchIDShare.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>

static PierTouchIDShare *__shardInstance;
@interface PierTouchIDShare ()
@property (nonatomic, strong) LAContext *contex;
@end

@implementation PierTouchIDShare

+ (instancetype)sharedInstance
{
    if (!__shardInstance) {
        @synchronized (self)
        {
            if (!__shardInstance) {
                __shardInstance = [[PierTouchIDShare alloc] init];
                __shardInstance.contex = [[LAContext alloc] init];
            }
        }
    }
    return __shardInstance;
}


- (BOOL)hasTouchIDAuthority{
    BOOL result = NO;
    LAContext *laContex = [[PierTouchIDShare sharedInstance] contex];
    if (laContex == nil) {
        laContex = [[LAContext alloc] init];
    }
    NSError *errorInfo = nil;
    if ([laContex canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&errorInfo]){
        result = YES;
    }else{
        result = NO;
    }
    return result;
}

+ (void)startTouch:(TouchIDSuccessBlock)success
            cancel:(TouchIDCalcelBlock)cancel
            failed:(TouchIDFailedBlock)failed
     enterPassword:(TouchIDEnterPasswordBlock)enterPassword
{
    //不使用单例，否则不在识别新的touchID。
    LAContext *laContex = [[LAContext alloc] init];
    laContex.localizedFallbackTitle = @"Enter Text Message";
    NSError *errorInfo = nil;
    NSString *remark = @"Pier Payment";
    //TODO:TOUCHID是否存在
    if ([laContex  canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&errorInfo]) {
        //TODO:TOUCHID开始运作
        [laContex evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:remark reply:^(BOOL succes, NSError *error){
             if (succes) {
                 success();
             }else{
                 //识别超过3次、cancel、输入密码都会到这里
                 if (error.code == kLAErrorUserFallback) {
                     enterPassword();
                 } else if (error.code == kLAErrorUserCancel) {
                     cancel();
                 } else {
                     cancel();
                 }
                 
             }
         }];
    }else{
        failed();
    }
}

@end
