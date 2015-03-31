//
//  PierForgetPasswordViewController.m
//  PierPaySDK
//
//  Created by zyma on 3/31/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierForgetPasswordViewController.h"
#import "NSString+PierCheck.h"

@interface PierForgetPasswordViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSString *url;

@end

@implementation PierForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)initData{
    self.url = @"http://192.168.1.254:8080/umsite/index.html#/userForgetPassword";
}

- (void)initView{
    [self setTitle:@"Forget Password"];
    //get banks success
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block NSString *webContent = [self getHTMLStr];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([NSString emptyOrNull:webContent]) {
                webContent = @"Sorry,the page you requested doesn's exist or isn't available right now!";
            }
            [self.webView loadHTMLString:webContent baseURL:[NSURL URLWithString:self.url]];
        });
    });
}

- (NSString *)getHTMLStr
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:self.url]];
    [request setHTTPMethod:@"get"];
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (urlResponse.statusCode == 200) {
        NSString *resultStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        return resultStr;
    }
    else{
        return @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //启动指示器
//    self.indicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //关闭指示器
//    [self.indicatorView stopAnimating];
//    self.indicatorView.hidden = YES;
}

@end
