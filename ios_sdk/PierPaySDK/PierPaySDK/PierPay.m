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
#import "PierTouchIDShare.h"
#import "PierAlertView.h"
#import "NSString+PierCheck.h"

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

- (instancetype)initWith:(NSDictionary *)charge delegate:(id)delegate
{
    pierInitDataSource();
    __pierDataSource.merchantParam = [charge mutableCopy];
    __pierDataSource.pierDelegate = delegate;
    self = [super init];
    if (self) {
        _merchantAppHasBar = NO;
        PierPayRootViewController *pierUserCheckVC = [[PierPayRootViewController alloc] initWithNibName:@"PierPayRootViewController" bundle:pierBoundle()];
        [self addChildViewController:pierUserCheckVC];
    }
    return self;
}

+ (void)payWith:(NSDictionary *)charge delegate:(id)delegate{
    pierInitDataSource();
    __pierDataSource.merchantParam = [charge mutableCopy];
    __pierDataSource.pierDelegate = delegate;
    __pierDataSource.session_token = [charge objectForKey:@"session_token"];
    
    /** Device Token */
    //Touch ID 支付
//    if ([[PierTouchIDShare sharedInstance] hasTouchIDAuthority]) {
//        UIAlertView *payMentModelAlertView = [[UIAlertView alloc] initWithTitle:@"Pier Payment" message:[charge objectForKey:@"shop_name"] delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:
//                                              [charge objectForKey:@"amount"], @"TouchID", @"TextMessage", nil];
//        [payMentModelAlertView setTag:1003];
//        [payMentModelAlertView show];
//    }else{
//        [PierPay getPaymentSMS:delegate];
//    }
    
    NSString *amount = [NSString getNumberFormatterDecimalStyle:[__pierDataSource.merchantParam objectForKey:@"amount"] currency:[__pierDataSource.merchantParam objectForKey:@"currency"]];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Pier Payment",@"title",
                           amount,@"amount",nil];
    
    [PierPayModelAlertView showPierAlertView:self param:param selectTouchID:^BOOL{
        [PierTouchIDShare startTouch:^{
            [PierPay getPaymentSMS:__pierDataSource.pierDelegate];
        } cancel:^{
            [PierPay getPaymentSMS:__pierDataSource.pierDelegate];
        } failed:^{
        }];
        return YES;
    } selectSMS:^BOOL{
        return YES;
    } selectCancle:^BOOL{
        return YES;
    }];
    /*****************/
}

+ (void)createPayment:(NSDictionary *)charge{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://pier.com?amount=%@&currency=%@&merchant_id=%@&server_url=%@&scheme=%@&shop_name=%@", @"paywithpier",
                                       [charge objectForKey:@"amount"],
                                       [charge objectForKey:@"currency"],
                                       [charge objectForKey:@"merchant_id"],
                                       [charge objectForKey:@"server_url"],
                                       @"piermerchant",
                                        [charge objectForKey:@"shop_name"]]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://beta.itunes.apple.com/v1/invite/8f2643ef1c9747ac80332f76120c9f496977c937aa2a44648e6022a5fbf1c2e739c7fa37?ct=9KW7KNZ4KU&pt=2003"]];
    }
}

+ (void)handleOpenURL:(NSURL *)url withCompletion:(payWithPierComplete)completion{
    
}

#pragma mark - --------------------- service -----------------------

+ (void)getPaymentSMS:(id)delegate{
    PierTransactionSMSRequest *smsRequestModel = [[PierTransactionSMSRequest alloc] init];
    smsRequestModel.phone = [__pierDataSource.merchantParam objectForKey:DATASOURCES_PHONE];
    smsRequestModel.amount = [__pierDataSource.merchantParam objectForKey:DATASOURCES_AMOUNT];
    smsRequestModel.currency_code = [__pierDataSource.merchantParam objectForKey:DATASOURCES_CURRENCY];
    smsRequestModel.merchant_id = [__pierDataSource.merchantParam objectForKey:DATASOURCES_MERCHANT_ID];
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

