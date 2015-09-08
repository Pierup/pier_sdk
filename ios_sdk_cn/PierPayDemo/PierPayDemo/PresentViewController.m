//
//  PresentViewController.m
//  PierPayDemo
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PresentViewController.h"
#import "PierPaySDK.h"

@interface PresentViewController ()

@property (nonatomic, strong) PierPaySDK *pierPay;

@end

@implementation PresentViewController

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


- (IBAction)closeViewController:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
