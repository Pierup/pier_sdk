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
#import "PierJSONKit.h"

@interface PierPaySDK ()

@property (nonatomic, strong) PierWebViewController     *webViewController;
@property (nonatomic, strong) PierNavigationController  *navigationController;

@end

@implementation PierPaySDK

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createPayment:(NSDictionary *)charge
             delegate:(id)delegate
           fromScheme:(NSString *)fromScheme
           completion:(PayWithPierComplete)completion{
    [self initData:completion];
    __pierDataSource.merchantParam = [NSMutableDictionary dictionaryWithDictionary:charge];
    /** init view */
    _webViewController = [[PierWebViewController alloc] init];
    _navigationController = [[PierNavigationController alloc] initWithRootViewController:_webViewController];
    [self serviceSaveOrderInfo:charge];
}

- (void)initData:(PayWithPierComplete)completion{
    pierInitDataSource();
    __pierDataSource.completionBlock = completion;
}

#pragma mark - ----------------- service ---------------

- (void)serviceSaveOrderInfo:(NSDictionary *)charge{
    PierRequestSaveOrderInfoRequest *saveOrderInfoRequest = [[PierRequestSaveOrderInfoRequest alloc] init];
    saveOrderInfoRequest.order_id = [charge objectForKey:@"order_id"];
    saveOrderInfoRequest.api_id = [charge objectForKey:@"api_id"];
    saveOrderInfoRequest.merchant_id = [charge objectForKey:@"merchant_id"];
    saveOrderInfoRequest.amount = [charge objectForKey:@"amount"];
    NSArray *order_detail_list = [charge objectForKey:@"order_detail"];
    saveOrderInfoRequest.order_detail = [order_detail_list JSONString];
    saveOrderInfoRequest.return_url = [charge objectForKey:@"return_url"];
//    __weak __typeof(self)wself = self;
    [PierService serverSend:ePIER_API_SAVE_ORDER_INFO resuest:saveOrderInfoRequest successBlock:^(id responseModel) {
        PierRequestSaveOrderInfoResponse *response = responseModel;
        [__pierDataSource.merchantParam setObject:response.order_id forKey:@"order_id"];
        UIViewController *currentVC = [PierViewUtils getCurrentViewController];
        [currentVC presentViewController:_navigationController animated:YES completion:^{
            
        }];
    } faliedBlock:^(NSError *error) {
        
    } attribute:nil];
    
}

@end
