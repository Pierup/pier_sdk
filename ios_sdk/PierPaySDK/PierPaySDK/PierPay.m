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
#import "PierWebViewController.h"
#import "PierFont.h"
#import "PierPayModel.h"

/** Model View Close Button */
void setCloseBarButtonWithTarget(id target, SEL selector);

#pragma mark - -------------------- UI --------------------
#pragma mark - viewController

@interface PierPayRootViewController : UIViewController <PierPayServiceDelegate>

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic, weak) IBOutlet UIButton *applyButton;

@property (nonatomic, weak) IBOutlet UIImageView *logoWhiteImageView;
@property (nonatomic, weak) IBOutlet UIImageView *whiteArrorImageView;
@property (nonatomic, weak) IBOutlet UIImageView *logoPurpleImageView;
@property (nonatomic, weak) IBOutlet UIImageView *purpleArrorImageView;
/** servire model */
@property (nonatomic, strong) PierUserAgreementResponse *usersResponseModel;

/** Terms And Privacy */
@property (nonatomic, weak) IBOutlet UIButton *termsButton;
@property (nonatomic, weak) IBOutlet UIButton *privicyButton;
@property (nonatomic, weak) IBOutlet UILabel *termsPerfixLabel;
@property (nonatomic, weak) IBOutlet UILabel *termsSufffixLabel;

@end

@implementation PierPayRootViewController

#pragma makr ------------------ 初始化 ------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self checkSavedUser:self];
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
    
    [_termsButton.titleLabel setFont:[PierFont customFontWithSize:15]];
    [_privicyButton.titleLabel setFont:[PierFont customFontWithSize:15]];
    [_termsPerfixLabel setFont:[PierFont customFontWithSize:17]];
    [_termsPerfixLabel setTextColor:[PierColor lightPurpleColor]];
    [_termsSufffixLabel setFont:[PierFont customFontWithSize:17]];
    [_termsSufffixLabel setTextColor:[PierColor lightPurpleColor]];
}

- (void)checkSavedUser:(id)delegate
{
    PierTransactionSMSRequest *smsRequestModel = [[PierTransactionSMSRequest alloc] init];
    
    NSString *phone = [NSString getUnNilString:[__pierDataSource getPhone]];
    NSString *countryCode = [NSString getUnNilString:[__pierDataSource getCountryCode]];
    NSString *password = [NSString getUnNilString:[__pierDataSource getPassword]];
    
    if (![NSString emptyOrNull:phone] && ![NSString emptyOrNull:countryCode] && ![NSString emptyOrNull:password]) {
        [__pierDataSource.merchantParam setValue:phone forKey:DATASOURCES_PHONE];
        [__pierDataSource.merchantParam setValue:countryCode forKey:DATASOURCES_COUNTRY_CODE];
        smsRequestModel.phone = phone;
        smsRequestModel.password = password;
        smsRequestModel.amount = [__pierDataSource.merchantParam objectForKey:DATASOURCES_AMOUNT];
        smsRequestModel.currency_code = [__pierDataSource.merchantParam objectForKey:DATASOURCES_CURRENCY];
        smsRequestModel.merchant_id = [__pierDataSource.merchantParam objectForKey:DATASOURCES_MERCHANT_ID];
        
        PierPayService *pierService = [[PierPayService alloc] init];
        pierService.delegate = delegate;
        pierService.smsRequestModel = smsRequestModel;
        [pierService serviceGetPaySMS];
    }
}

#pragma mark - ------------------------ PierPayServiceDelegate ------------------------

- (void)pierPayServiceComplete:(NSDictionary *)result
{
    NSInteger status = [[result objectForKey:@"status"] integerValue];
    switch (status) {
        case 0:
        {
            // Return to Merchant APP
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [__pierDataSource.pierDelegate payWithPierComplete:result];
            }];
            break;
        }
        case 1:
        {
            // Return to Merchant APP
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [__pierDataSource.pierDelegate payWithPierComplete:result];
            }];
            break;
        }
        case 2:
            
            break;
        default:
            break;
    }

}

- (void)pierPayServiceFailed:(NSError *)error
{
    NSDictionary *alertParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"icon_error",@"title_image_name",
                                @"error",@"title",
                                [error domain],@"message",nil];
    [PierAlertView showPierAlertView:self param:alertParam type:ePierAlertViewType_error approve:^(NSString *userInput) {
        return YES;
    }];
}



#pragma mark --------------- button Action ------------------------

- (void)closeBarButtonClicked:(id)sender
{
    if ([self.navigationController.viewControllers count] == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)termsButtonAction:(UIButton *)sender
{
    if (self.usersResponseModel) {
        [self pushToWebView:1];
    }else{
        [self serviceGetURLS:1];
    }
}

- (IBAction)policyButtonAction:(UIButton *)sender
{
    if (self.usersResponseModel) {
        [self pushToWebView:2];
    }else{
        [self serviceGetURLS:2];
    }
}


/**
 * @pramr type:1 terms 2 privacy
 */
- (void)pushToWebView:(NSInteger)type{
    PierWebViewController *forgetPassword = [[PierWebViewController alloc] initWithNibName:@"PierWebViewController" bundle:pierBoundle()];
    switch (type) {
        case 1:
        {
            forgetPassword.url = self.usersResponseModel.url_term;
            forgetPassword.title = @"Terms";
            break;
        }
        case 2:{
            forgetPassword.url = self.usersResponseModel.url_privacy;
            forgetPassword.title = @"Privacy";
            break;
        }
        default:
            break;
    }

    [self.navigationController pushViewController:forgetPassword animated:NO];
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

- (void)serviceGetURLS:(NSInteger)type
{
    PierUserAgreementRequest *requestModel = [[PierUserAgreementRequest alloc] init];
    
    [PierService serverSend:ePIER_APU_GET_URLS resuest:requestModel successBlock:^(id responseModel) {
        self.usersResponseModel = (PierUserAgreementResponse *)responseModel;
        [self pushToWebView:type];
    } faliedBlock:^(NSError *error) {
        
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"show_alert",@"0",@"show_loading", nil]];
}

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
    if ([[PierTouchIDShare sharedInstance] hasTouchIDAuthority]) {
        NSString *amount = [NSString getNumberFormatterDecimalStyle:[__pierDataSource.merchantParam objectForKey:@"amount"] currency:[__pierDataSource.merchantParam objectForKey:@"currency"]];
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Pier Payment",@"title",
                               amount,@"amount",nil];
        
        [PierPayModelAlertView showPierAlertView:self param:param selectTouchID:^BOOL{
            [PierTouchIDShare startTouch:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PierPay getPaymentSMS:__pierDataSource.pierDelegate payType:3];
                });
            } cancel:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"1",@"status",
                                            @"Payment Cancel",@"message", nil];
                    [__pierDataSource.pierDelegate payWithPierComplete:result];
                });
            } failed:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"1",@"status",
                                            @"TouchID identification failure",@"message", nil];
                    [__pierDataSource.pierDelegate payWithPierComplete:result];
                });
            } enterPassword:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PierPay payWith:charge delegate:delegate];
                });
            } ];
            return YES;
        } selectSMS:^BOOL{
            dispatch_async(dispatch_get_main_queue(), ^{
                [PierPay getPaymentSMS:delegate payType:1];
            });
            return YES;
        } selectCancle:^BOOL{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"1",@"status",
                                        @"Payment Cancel",@"message", nil];
                [__pierDataSource.pierDelegate payWithPierComplete:result];
            });
            return YES;
        }];
    }else{
        [PierPay getPaymentSMS:delegate payType:1];
    }
}

+ (void)createPayment:(NSDictionary *)charge{
    /**
     * status：
     * App中支付完成 App->Merchant:   1 支付成功；2 支付失败
     * SDK创建支付后 App->Merchant:   3 跳转到商家
     */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://pier.com?status=3&amount=%@&currency=%@&merchant_id=%@&server_url=%@&scheme=%@&shop_name=%@", @"paywithpier",
                                       [NSString getUnNilString:[charge objectForKey:@"amount"]],
                                       [NSString getUnNilString:[charge objectForKey:@"currency"]],
                                       [NSString getUnNilString:[charge objectForKey:@"merchant_id"]],
                                       [NSString getUnNilString:[charge objectForKey:@"server_url"]],
                                       @"piermerchant",
                                       [NSString getUnNilString:[charge objectForKey:@"shop_name"]]]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://beta.itunes.apple.com/v1/invite/8f2643ef1c9747ac80332f76120c9f496977c937aa2a44648e6022a5fbf1c2e739c7fa37?ct=9KW7KNZ4KU&pt=2003"]];
    }
}

+ (void)handleOpenURL:(NSURL *)url withCompletion:(payWithPierComplete)completion{
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dicQuery = [PierPay parseURLQueryString:query];
    completion(dicQuery,nil);
}

#pragma mark - --------------------- service -----------------------

+ (void)getPaymentSMS:(id)delegate payType:(ePierPaymentType)payType{
    PierTransactionSMSRequest *smsRequestModel = [[PierTransactionSMSRequest alloc] init];
    smsRequestModel.phone = [__pierDataSource.merchantParam objectForKey:DATASOURCES_PHONE];
    smsRequestModel.amount = [__pierDataSource.merchantParam objectForKey:DATASOURCES_AMOUNT];
    smsRequestModel.currency_code = [__pierDataSource.merchantParam objectForKey:DATASOURCES_CURRENCY];
    smsRequestModel.merchant_id = [__pierDataSource.merchantParam objectForKey:DATASOURCES_MERCHANT_ID];

    PierPayService *pierService = [[PierPayService alloc] init];
    pierService.delegate = delegate;
    pierService.smsRequestModel = smsRequestModel;
    
    if (payType == ePierPaymentType_TouchID) {
        //DATASOURCES_DEVICETOKEN
        NSString *device_token = [__pierDataSource.merchantParam objectForKey:DATASOURCES_DEVICETOKEN];
        [pierService serviceGetAuthToken:device_token type:payType];
    }else {
        [pierService serviceGetPaySMS:YES payWith:ePierPayWith_PierApp];
    }
    
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

#pragma mark - -------------------- Tools -------------------

+ (NSDictionary *)parseURLQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for(NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        if([keyValue count] == 2) {
            NSString *key = [keyValue objectAtIndex:0];
            NSString *value = [keyValue objectAtIndex:1];
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if(key && value)
                [dict setObject:value forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
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
