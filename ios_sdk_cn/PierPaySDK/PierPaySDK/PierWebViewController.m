//
//  PierWebViewController.m
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PierWebViewController.h"
#import "PierH5Utils.h"

@interface PierWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PierWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://pierup.cn:4000"]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    //bar
    [self setRightBarButton:@"关闭"];
    [self setLeftBarButton:@"返回"];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
}

/**
 * Close Button
 */
- (void)setRightBarButton:(NSString *)title{
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBarButton.frame = CGRectMake(0, 0, 32, 32);
    [rightBarButton setTitle:title forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(closeViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

/**
 * Close Action
 */
- (void)closeViewController:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/**
 * Back Button
 */
- (void)setLeftBarButton:(NSString *)title{
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBarButton.frame = CGRectMake(0, 0, 32, 32);
    [leftBarButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBarButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

/**
 * Back Action
 */
- (void)backAction:(id)sender{
    [self.webView goBack];
}


#pragma mark - ------------------- UIWebViewDelegate -------------------

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = [PierH5Utils getWebTitle:self.webView];
    [self setTitle:title];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


#pragma mark - ---------------- Utils ----------------


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
