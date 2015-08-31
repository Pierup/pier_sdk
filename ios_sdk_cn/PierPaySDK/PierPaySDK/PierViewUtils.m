//
//  PierViewUtils.m
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PierViewUtils.h"

@implementation PierViewUtils

+ (UIViewController *)getCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id rootViewController = window.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = ((UINavigationController *)rootViewController).topViewController;
        
        // 顶层模态视图获取逻辑
        while (((UIViewController *)rootViewController).presentedViewController) {
            rootViewController = ((UIViewController *)rootViewController).presentedViewController;
        }
        
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            UIViewController *visibleViewController = ((UINavigationController *)rootViewController).visibleViewController;
            if (visibleViewController) {
                rootViewController = visibleViewController;
            }
        }
    }
    return rootViewController;
//    UIViewController* activityViewController = nil;
//    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    if(window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow *tmpWin in windows)
//        {
//            if(tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    
//    NSArray *viewsArray = [window subviews];
//    if([viewsArray count] > 0)
//    {
//        UIView *frontView = [viewsArray objectAtIndex:0];
//        
//        id nextResponder = [frontView nextResponder];
//        
//        if([nextResponder isKindOfClass:[UIViewController class]])
//        {
//            activityViewController = nextResponder;
//        }else {
//            activityViewController = window.rootViewController;
//        }
//    }
//    
//    return activityViewController;
}

@end
