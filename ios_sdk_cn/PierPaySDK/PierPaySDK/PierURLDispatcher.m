//
//  PierURLDispatcher.m
//  PierPaySDK
//
//  Created by zyma on 9/9/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PierURLDispatcher.h"
#import "PierH5Utils.h"
#import "PierJSONKit.h"

static PierURLDispatcher * __instance;

@implementation PierWebActionModel


@end

@implementation PierURLDispatcher

//+ (PierURLDispatcher *)shareInstance{
//    if (__instance == nil) {
//        @synchronized(self){
//            if (__instance == nil) {
//                __instance = [[PierURLDispatcher alloc] init];
//            }
//        }
//    }
//    return __instance;
//}

- (BOOL)dispatchURL:(NSURL *)url viewController:(UIViewController *)viewController{
    /**
     * pierpay://pier?platform=ios&result=""
     */
    NSString *scheme = [url scheme];
    NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *query_dic = [PierH5Utils parseURLQueryString:query];
    ePierAction action = [[query_dic objectForKey:@"action"] integerValue];
    if ([scheme isEqualToString:@"pierpay"]) {
        NSString *result = [query_dic objectForKey:@"result"];
        NSDictionary *result_dic = [result objectFromJSONString];
        switch (action) {
            case ePierAction_login:
                
                break;
            case ePierAction_pay:
                
                break;
            case ePierAction_return:{
                PierWebActionModel *model = [[PierWebActionModel alloc] init];
                model.action_type = ePierAction_return;
                model.result = result_dic;
                if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcheFinish:)]) {
                    [self.delegate dispatcheFinish:model];
                }
                [viewController popoverPresentationController];
                break;
            }
            default:
                break;
        }
        return NO;
    }else{
        switch (action) {
            case ePierAction_login:{
                break;
            }
            case ePierAction_login_to_confirm:{
                
                break;
            }
            case ePierAction_login_to_regist:{
                
                break;
            }
            case ePierAction_login_to_pay:{
                
                break;
            }
            default:
                break;
        }
        PierWebActionModel *model = [[PierWebActionModel alloc] init];
        model.action_type = action;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dispatcheFinish:)]) {
            [self.delegate dispatcheFinish:model];
        }
        return YES;
    }
}

@end
