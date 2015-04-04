//
//  PierForgetPasswordViewController.m
//  PierPaySDK
//
//  Created by zyma on 3/31/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierWebViewController.h"
#import "NSString+PierCheck.h"

@interface PierWebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation PierWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
    [self startLoadWebPage:self.url];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)startLoadWebPage:(NSString *)url{
    self.url = url;
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

- (void)initData{
    self.webView.delegate = self;
//    self.url = @"http://192.168.1.254:8080/umsite/index.html#/userForgetPassword";
}

- (void)initView{
    [self.indicatorView setHidesWhenStopped:YES];
    [self.indicatorView startAnimating];
    [self setTitle:self.title];
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
    [self.indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //关闭指示器
    [self.indicatorView stopAnimating];
}

@end
