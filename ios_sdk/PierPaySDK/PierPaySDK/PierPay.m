//
//  PierPaySDK.m
//  PierPaySDK
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "PierPay.h"
#import "PierHttpClient.h"
#import "PierService.h"
#import "PierPayModel.h"
#import "PierConfig.h"
#import "PierLoginViewController.h"
#import "PierTools.h"
#import "PierSiginViewController.h"
#import "PierDataSource.h"
#import "PierColor.h"
#import "PierViewUtil.h"
#import "PierPayService.h"

/** Model View Close Button */
void setCloseBarButtonWithTarget(id target, SEL selector);

#pragma mark - -------------------- UI --------------------
#pragma mark - viewController

@interface PierPayRootViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic, weak) IBOutlet UIButton *applyButton;

@property (nonatomic, weak) IBOutlet UIImageView *logoWhiteImageView;
@property (nonatomic, weak) IBOutlet UIImageView *whiteArrorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *logoPurpleImageView;
@property (nonatomic, weak) IBOutlet UIImageView *purpleArrorImageView;

@end

@implementation PierPayRootViewController

#pragma makr ------------------ 初始化 ------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}


- (void)initView{
    [self setTitle:@"Pay By Pier"];
    [self.closeButton setBackgroundColor:[UIColor clearColor]];
    [self.closeButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"btn_close")] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    setCloseBarButtonWithTarget(self, @selector(closeBarButtonClicked:));
    
    [self.logoWhiteImageView setImage:[UIImage imageWithContentsOfFile:getImagePath(@"icon_logowhite")]];
    [self.whiteArrorImageView setImage:[UIImage imageWithContentsOfFile:getImagePath(@"btn_next")]];
   
    [self.logoPurpleImageView setImage:[UIImage imageWithContentsOfFile:getImagePath(@"icon_logopurple")]];
    [self.purpleArrorImageView setImage:[UIImage imageWithContentsOfFile:getImagePath(@"btn_nextpurple")]];
    
    [self.payButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *payBtnImg = [PierViewUtil getImageByView:self.payButton];
    [self.payButton setBackgroundImage:payBtnImg forState:UIControlStateNormal];


    [self.payButton.layer setMasksToBounds:YES];
    [self.payButton.layer setCornerRadius:5];
    
    [self.applyButton setBackgroundImage:[PierViewUtil getImageByView:self.applyButton] forState:UIControlStateNormal];
    [self.applyButton.layer setBorderWidth:1.0];
    [self.applyButton.layer setBorderColor:[[PierColor darkPurpleColor] CGColor]];
    [self.applyButton.layer setMasksToBounds:YES];
    [self.applyButton.layer setCornerRadius:5];
    
}

#pragma mark --------------- button Action ------------------------

- (void)closeBarButtonClicked:(id)sender
{
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)termsAndPolicyButtonAction:(UIButton *)sender
{
    
}

- (IBAction)loginAction:(id)sender
{
    PierLoginViewController *loginPage = [[PierLoginViewController alloc] initWithNibName:@"PierLoginViewController" bundle:pierBoundle()];
    [self.navigationController pushViewController:loginPage animated:YES];
}

- (IBAction)creditApplay:(id)sender
{
    PierSiginViewController *creditApplay = [[PierSiginViewController alloc] initWithNibName:@"PierSiginViewController" bundle:pierBoundle()];
    [self.navigationController pushViewController:creditApplay animated:YES];
}

#pragma mark --------------------- Service ---------------------------

#pragma mark ----------------------退出清空 ------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#pragma mark - navigationController

@interface PierPay ()

@property (nonatomic, assign) BOOL merchantAppHasBar;

@end

@implementation PierPay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWith:(NSDictionary *)userAttributes delegate:(id)delegate
{
    pierInitDataSource();
    __pierDataSource.merchantParam = [userAttributes mutableCopy];
    __pierDataSource.pierDelegate = delegate;
    self = [super init];
    if (self) {
        _merchantAppHasBar = NO;
        PierPayRootViewController *pierUserCheckVC = [[PierPayRootViewController alloc] initWithNibName:@"PierPayRootViewController" bundle:pierBoundle()];
        [self addChildViewController:pierUserCheckVC];
    }
    return self;
}

+ (void)payWith:(NSDictionary *)userAttributes delegate:(id)delegate{
    pierInitDataSource();
    __pierDataSource.merchantParam = [userAttributes mutableCopy];
    __pierDataSource.pierDelegate = delegate;
    __pierDataSource.session_token = [userAttributes objectForKey:@"session_token"];
    
    PierTransactionSMSRequest *smsRequestModel = [[PierTransactionSMSRequest alloc] init];
    smsRequestModel.phone = [__pierDataSource.merchantParam objectForKey:DATASOURCES_PHONE];
    smsRequestModel.amount = [__pierDataSource.merchantParam objectForKey:DATASOURCES_AMOUNT];
    smsRequestModel.currency_code = [__pierDataSource.merchantParam objectForKey:DATASOURCES_CURRENCY];
    PierPayService *pierService = [[PierPayService alloc] init];
    pierService.delegate = delegate;
    pierService.smsRequestModel = smsRequestModel;
    [pierService serviceGetPaySMS:YES payWith:ePierPayWith_PierApp];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (self.navigationBar.hidden == NO) {
        _merchantAppHasBar = NO;
        [self setNavigationBarHidden:YES animated:YES];
    }else{
        _merchantAppHasBar = YES;
    }
//    NSArray *path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString *documentPath = [path1 objectAtIndex:0];
//    NSLog(@"path=%@",documentPath);
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (!_merchantAppHasBar) {
        [self setNavigationBarHidden:NO animated:YES];
    }
}

@end

#pragma mark - -------------------- Tools -------------------

#pragma mark- Model View Close Button
void setCloseBarButtonWithTarget(id target, SEL selector)
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* image = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    UIImage* pressedImage = [UIImage imageWithContentsOfFile:getImagePath(@"btn_close")];
    [customButton setImage:image forState:UIControlStateNormal];
    [customButton setImage:pressedImage forState:UIControlStateHighlighted];
    
    [customButton setFrame:CGRectMake(0, 0, 44, 44)];
    [customButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    
    UIViewController *vc = (UIViewController *)target;
    vc.navigationItem.rightBarButtonItem = item;
}

