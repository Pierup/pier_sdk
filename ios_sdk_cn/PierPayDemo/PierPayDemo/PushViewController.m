//
//  PushViewController.m
//  PierPayDemo
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PushViewController.h"
#import "PierPaySDK.h"

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
    _pierPay = [[PierPaySDK alloc] init];
    [_pierPay createPayment:nil delegate:self fromScheme:@"" completion:^(NSDictionary *result, NSError *error) {
        
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
