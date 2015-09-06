//
//  PushViewController.m
//  PierPayDemo
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PushViewController.h"
#import "PierPaySDK.h"
#import "RSADigitalSignature.h"
#import "OrderUtil.h"

@interface PushViewController ()

@property (nonatomic, strong) PierPaySDK *pierPay;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payByPier:(id)sender{
    NSDictionary *param = @{
                             @"merchant_id":@"MC0000001409",
                             @"api_id":@"1819957c-1a3f-11e5-ba25-3a22fd90d682",
                             @"api_secret_key":@"mk-prod-18199475-1a3f-11e5-ba25-3a22fd90d682",
                             @"amount":@"11.01",
                             @"charset":@"UTF-8",
                             @"order_id":@"",
                             @"return_url":@"",
                             @"order_detail":@"",
                             @"sign_type":@"RSA"
                             };
    
    NSString *sign = [OrderUtil getSgin:param];
    
    NSDictionary *charge = @{
                             @"merchant_id":@"MC0000001409",
                             @"api_id":@"1819957c-1a3f-11e5-ba25-3a22fd90d682",
                             @"api_secret_key":@"mk-prod-18199475-1a3f-11e5-ba25-3a22fd90d682",
                             @"amount":@"11.01",
                             @"charset":@"UTF-8",
                             @"order_id":@"",
                             @"return_url":@"",
                             @"order_detail":@"",
                             @"sign_type":@"RSA",
                             @"sign":sign
                             };
    
    _pierPay = [[PierPaySDK alloc] init];
    
    [_pierPay createPayment:charge delegate:self fromScheme:@"" completion:^(NSDictionary *result, NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
