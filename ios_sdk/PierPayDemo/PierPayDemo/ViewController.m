//
//  ViewController.m
//  PierPayDemo
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "ViewController.h"
#import "PierPay.h"
#import "DemoHttpExecutor.h"
#import "ShopListViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UINavigationController *mainViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
//    [self.phoneLabel becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
//    [self.phoneLabel resignFirstResponder];
}

- (void)initData{

}

- (void)initView{
    if (!self.mainViewController) {
        ShopListViewController *viewController = [[ShopListViewController alloc]init];
        self.mainViewController = [[UINavigationController alloc]initWithRootViewController:viewController];
    }
    [self.view addSubview:self.mainViewController.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)setMerchantParam{
}
@end
