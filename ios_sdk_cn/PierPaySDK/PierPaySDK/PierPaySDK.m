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
#import "PierDataSource.h"
#include "PierNavigationController.h"
#import "PierWebViewController.h"
#import "PierPayModel.h"
#import "PierService.h"

@interface PierPaySDK ()

@property (nonatomic, strong) PierWebViewController     *webViewController;
@property (nonatomic, strong) PierNavigationController  *navigationController;

@end

@implementation PierPaySDK

- (void)createPayment:(NSDictionary *)charge
             delegate:(id)delegate
           fromScheme:(NSString *)fromScheme
           completion:(PayWithPierComplete)completion{
    /** init view */
    UIViewController *currentVC = [PierViewUtils getCurrentViewController];
    _webViewController = [[PierWebViewController alloc] init];
    _webViewController.charge = charge;
    _navigationController = [[PierNavigationController alloc] initWithRootViewController:_webViewController];
    __weak __typeof(self)wself = self;
    [currentVC presentViewController:_navigationController animated:YES completion:^{
        [wself serviceSaveOrderInfo:charge];
    }];
}

- (void)initData:(PayWithPierComplete)completion{
    pierInitDataSource();
    __pierDataSource.completionBlock = completion;
}

#pragma mark - ----------------- service ---------------

- (void)serviceSaveOrderInfo:(NSDictionary *)charge{
    PierRequestSaveOrderInfoRequest *saveOrderInfoRequest = [[PierRequestSaveOrderInfoRequest alloc] init];
    saveOrderInfoRequest.order_id = [charge objectForKey:@"order_id"];
    saveOrderInfoRequest.merchant_id = [charge objectForKey:@"merchant_id"];
    saveOrderInfoRequest.amount = [charge objectForKey:@"amount"];
    saveOrderInfoRequest.order_detail = [charge objectForKey:@"order_detail"];
    
    [PierService serverSend:ePIER_API_SAVE_ORDER_INFO resuest:saveOrderInfoRequest successBlock:^(id responseModel) {
        
    } faliedBlock:^(NSError *error) {
        
    } attribute:nil];
    
}

@end
