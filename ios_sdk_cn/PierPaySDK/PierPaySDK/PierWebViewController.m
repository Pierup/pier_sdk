//
//  PierWebViewController.m
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "PierWebViewController.h"
#import "PierH5Utils.h"
#include "PierLoadingView.h"
#import "PierDataSource.h"
#import "PierURLDispatcher.h"

@interface PierWebViewController () <UIWebViewDelegate, PierURLDispatcherDeleagte>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) PierURLDispatcher *dispatcher;

@end

NSString * const PIER_SDK_ROOT_URL = @"http://pierup.cn:4000/mobile/checkout/login";

@implementation PierWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dispatcher = [[PierURLDispatcher alloc] init];
        _dispatcher.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self startLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    //bar
    [self setRightBarButton:@"取消"];
    [self setLeftBarButton:@"返回"];
    [self setLefrBarHidden:YES];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_webView
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_webView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view attribute:NSLayoutAttributeTop
                              multiplier:1
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_webView
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeft
                              multiplier:1
                              constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:_webView
                              attribute:NSLayoutAttributeRight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeRight
                              multiplier:1
                              constant:0]];
}

/**
 * start loading
 * test:http://pierup.cn:4000/mobile/checkout/login?merchant=MC0000001409&order=OR6369705751050&sign=1bYPJykhrPya1BC3%2Ftbr14lghwXyKMFQdj5MAUU%2Bl9JaPPUQyYkOhSrqDkm%2BFTGAtVLHX2qKrMU86pSkrNJB%2FIuTemq4NRESrBonK4WeHAP%2FDsdXZqilUV8Mda3VttvpmOp2p0Y5NnpJ0B6K%2FGIY8msEvc%2FGlSps%2F%2FEQJn6YF1Y%3D&sign_type=RSA&charset=UTF-8
 */
- (void)startLoading{
    NSString *query = [self getURLParam];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", PIER_SDK_ROOT_URL, query] relativeToURL:[NSURL URLWithString:PIER_SDK_ROOT_URL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}

/**
 * 获取url 参数列表
 */
- (NSString *)getURLParam{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[__pierDataSource.merchantParam objectForKey:@"merchant_id"] forKey:@"merchant"];
    [paramDic setObject:[__pierDataSource.merchantParam objectForKey:@"charset"] forKey:@"charset"];
    [paramDic setObject:[__pierDataSource.merchantParam objectForKey:@"order_id"] forKey:@"order"];
    [paramDic setObject:[__pierDataSource.merchantParam objectForKey:@"sign"] forKey:@"sign"];
    [paramDic setObject:[__pierDataSource.merchantParam objectForKey:@"sign_type"] forKey:@"sign_type"];
    [paramDic setObject:@"ios" forKey:@"platform"];
    return [PierH5Utils getURLQurey:paramDic];
}

#pragma mark - ---------------------- item bar ----------------------

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
    _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _leftButton.frame = CGRectMake(0, 0, 32, 32);
    [_leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

/**
 * Back Button
 */
- (void)setLefrBarHidden:(BOOL)hidden{
    if (hidden) {
        [self.leftButton setHidden:YES];
    }else{
        [self.leftButton setHidden:NO];
    }
}

/**
 * Back Action
 */
- (void)backAction:(id)sender{
    [self.webView goBack];
}


#pragma mark - ------------------- UIWebViewDelegate -------------------

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return [_dispatcher dispatchURL:[request URL] viewController:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [PierLoadingView showLoadingView:@"加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self loadFinish:webView];
    NSString *title = [PierH5Utils getWebTitle:self.webView];
    [self setTitle:title];
    [PierLoadingView hindLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error.domain delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    [PierLoadingView hindLoadingView];
}

#pragma mark - ---------------- PierURLDispatcherDeleagte ----------------------

- (void)dispatcheFinish:(PierWebActionModel *)model{
    switch (model.action_type) {
        case ePierAction_return:
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                __pierDataSource.completionBlock(model.result, nil);
            }];
            break;
        }
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
        default:{
            break;
        }
    }
}

- (void)loadFinish:(UIWebView *)webView{
    PierWebInfoModel *pageModel = [PierH5Utils getPageInfo:webView];
    [self setLefrBarHidden:NO];
    switch (pageModel.paye_id) {
        case ePierPageID_login:
            [self setLefrBarHidden:YES];
            break;
        case ePierPageID_confirm:
            break;
        case ePierPageID_regist:
            break;
        default:
            break;
    }
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
