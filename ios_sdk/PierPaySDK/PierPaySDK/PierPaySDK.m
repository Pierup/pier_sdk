//
//  PierPaySDK.m
//  PierPaySDK
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PierPaySDK.h"
#import "PIRHttpClient.h"

static NSString *__bundlePath;

/** Get iPhone Version */
double IPHONE_OS_MAIN_VERSION();
/** Get ImageName in Bundle */
NSString *getImagePath(NSString *imageName);
/** Model View Close Button */
void setCloseBarButtonWithTarget(id target, SEL selector);

@implementation PierPaySDK

+ (void)test:(NSString *)text{
    NSLog(@"%@",text);
    
}

@end

#pragma mark - -------------------- UI --------------------
#pragma mark - viewController

@interface PierUserInfuCheckViewController : UIViewController

@end

@implementation PierUserInfuCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView{
    [self setTitle:@"Pay By Pier"];
    setCloseBarButtonWithTarget(self, @selector(closeBarButtonClicked:));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeBarButtonClicked:(id)sender
{
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)submitButtonAction:(id)sender{
    NSString *testURL = @"http://101.44.12.69:8686/pier_api/v1/user/get_countries";
    [[PIRHttpClient sharedInstanceWithClientType:ePIRHttpClientType_User] GET:testURL saveToPath:nil parameters:nil progress:^(float progress) {
        
    } success:^(id response, NSHTTPURLResponse *urlResponse) {
        NSLog(@"response:%@",response);
    } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"urlResponse:%@",urlResponse);
    }];
}

@end

#pragma mark - navigationController

@interface PierCredit ()
@end

@implementation PierCredit

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString *documentPath = [path1 objectAtIndex:0];
//    NSLog(@"path=%@",documentPath);

    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"PierResource" withExtension:@"bundle"]];
    
    PierUserInfuCheckViewController *pierUserCheckVC = [[PierUserInfuCheckViewController alloc] initWithNibName:@"PierUserInfuCheckViewController" bundle:bundle];
    [self addChildViewController:pierUserCheckVC];
}


@end

#pragma mark - -------------------- Tools -------------------
#pragma mark - Get iPhone Version
double IPHONE_OS_MAIN_VERSION() {
    static double __iphone_os_main_version = 0.0;
    if(__iphone_os_main_version == 0.0) {
        NSString *sv = [[UIDevice currentDevice] systemVersion];
        NSScanner *sc = [[NSScanner alloc] initWithString:sv];
        if(![sc scanDouble:&__iphone_os_main_version])
            __iphone_os_main_version = -1.0;
    }
    return __iphone_os_main_version;
}

#pragma mark - Get ImageName in Bundle
NSString *getImagePath(NSString *imageName){
    NSString *path = @"";
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"PierResource" withExtension:@"bundle"]];
    
//    NSString *bindlePath = [[NSBundle mainBundle] pathForResource:@"PierResource" ofType:@"bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:bindlePath];
    path = [bundle pathForResource:imageName ofType:@"png"];
    return path;
}

#pragma mark- Model View Close Button
void setCloseBarButtonWithTarget(id target, SEL selector)
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    UIImage* pressedImage = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    [customButton setImage:image forState:UIControlStateNormal];
    [customButton setImage:pressedImage forState:UIControlStateHighlighted];
    
    [customButton setFrame:CGRectMake(0, 0, 20, 20)];
    [customButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    UIViewController *vc = (UIViewController *)target;
    vc.navigationItem.rightBarButtonItem = item;
}