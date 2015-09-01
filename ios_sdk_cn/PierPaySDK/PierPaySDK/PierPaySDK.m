//
//  PierPaySDK.m
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PierPaySDK.h"
#import "PierViewUtils.h"
#include "PierNavigationController.h"
#import "PierWebViewController.h"

@interface PierPaySDK ()

@property (nonatomic, strong) PierWebViewController     *webViewController;
@property (nonatomic, strong) PierNavigationController  *navigationController;

@end

@implementation PierPaySDK

- (void)createPayment:(NSDictionary *)charge
             delegate:(id)delegate
           fromScheme:(NSString *)fromScheme
           completion:(payWithPierComplete)completion{
    /** init view */
    UIViewController *currentVC = [PierViewUtils getCurrentViewController];
    _webViewController = [[PierWebViewController alloc] init];
    _navigationController = [[PierNavigationController alloc] initWithRootViewController:_webViewController];
    [currentVC presentViewController:_navigationController animated:YES completion:^{
        
    }];
}

@end
