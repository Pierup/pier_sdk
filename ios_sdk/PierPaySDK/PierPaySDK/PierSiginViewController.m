//
//  PierSiginViewController.m
//  PierPaySDK
//
//  Created by zyma on 3/2/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierSiginViewController.h"
#import "PIRService.h"
#import "PierTools.h"
#import "PierColor.h"
#import "NSString+Check.h"
#import "PierRegisterViewController.h"
#import "PIRViewUtil.h"
#import "PierAlertView.h"
#import "PierCountryCodeViewController.h"
#import "PIRDataSource.h"

@interface PierSiginViewController ()<PierCountryCodeViewControllerDelegate, UITextFieldDelegate, PierSMSInputAlertDelegate>

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UIView *textRemarkLabel;
@property (nonatomic, weak) IBOutlet UIButton *countryCodeButton;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) PierCountryCodeViewController *countryCodeViewController;
@property (nonatomic, strong) CountryModel *country;

@property (nonatomic, strong) PierSMSAlertView *smsAlertView;

@end

@implementation PierSiginViewController

#pragma mark - -------------------- System -----------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.countryCodeViewController = [[PierCountryCodeViewController alloc]initWithNibName:@"PierCountryCodeViewController" bundle:pierBoundle()];
            self.countryCodeViewController.delegate = self;
        _country = [[CountryModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneNumberLabel becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneNumberLabel resignFirstResponder];
}

- (void)initData
{
#warning ----------------------------- 硬编码 ------------------
    NSString *countryCode = __dataSource.country_code;
    self.country.country_code = countryCode;
    if ([countryCode isEqualToString:@"US"]) {
        self.country.phone_prefix = @"1";
        self.country.phone_size = @"10";
        self.country.name  = @"UNITED STATES";
    }else if ([countryCode isEqualToString:@"CN"]) {
        self.country.phone_prefix = @"86";
        self.country.phone_size = @"11";
        self.country.name  = @"CHINA";
    }
    [self checkCountryCodeWithCountry:self.country phoneNumber:self.phoneNumberLabel.text];
}

- (void)initView
{
    [self.submitButton setBackgroundColor:[PierColor darkPurpleColor]];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:5];

    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.phoneLabel setTextColor:[PierColor lightGreenColor]];
    
    [self.phoneNumberLabel setTintColor:[PierColor lightPurpleColor]];
    self.phoneNumberLabel.delegate  = self;
}

#pragma mark ------------------- button Action ------------------------

#pragma mark - bacButton Action
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - submitButton Action
- (IBAction)userRegisterAction:(id)sender
{
    self.phone = [self.phoneNumberLabel.text phoneClearFormat];
    if ([self checkPhone]) {
        [self serviceGetReigistSMS];
    }
}

#pragma makr - countryCodeButton Action
- (IBAction)countryCodeButtonAction:(UIButton *)sender
{
    UINavigationController *countryNav = [[UINavigationController alloc] initWithRootViewController:self.countryCodeViewController];
    [self presentViewController:countryNav animated:YES completion:^{
        [self.navigationController setNavigationBarHidden:YES];
    }];
}

#pragma mark - -------------------- 接口API ----------------------------

- (void)serviceGetReigistSMS
{
    GetRegisterCodeRequest *requestModel = [[GetRegisterCodeRequest alloc] init];
    requestModel.phone = self.phone;
    
    [PIRService serverSend:ePIER_API_GET_ACTIVITY_CODE resuest:requestModel successBlock:^(id responseModel) {
        GetRegisterCodeResponse *response = (GetRegisterCodeResponse *)responseModel;
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"",@"title_image_name",
                               @"SMS",@"title",
                               @"Next",@"approve_text",
                               @"Dismiss",@"cancle_text",
                               self.phone,@"phone",
                               response.expiration,@"expiration_time",
                               @"6",@"code_length",nil];
        _smsAlertView = [[PierSMSAlertView alloc] initWith:self param:param type:ePierAlertViewType_instance];
        _smsAlertView.delegate = self;
        [_smsAlertView show];
    } faliedBlock:^(NSError *error) {
        
    } attribute:nil];
}

- (void)serviceSMSActivation:(NSString *)activation_code
{
    RegSMSActiveRequest *requestModel = [[RegSMSActiveRequest alloc] init];
    requestModel.phone = self.phone;
    requestModel.activation_code = activation_code;
    
    [PIRService serverSend:ePIER_API_GET_ACTIVITION resuest:requestModel successBlock:^(id responseModel) {
        RegSMSActiveResponse *reqponse = (RegSMSActiveResponse *)responseModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_smsAlertView dismiss];
            PierRegisterViewController *loginPage = [[PierRegisterViewController alloc] initWithNibName:@"PierRegisterViewController" bundle:pierBoundle()];
            loginPage.token = reqponse.token;
            [self.navigationController pushViewController:loginPage animated:NO];
        });
    } faliedBlock:^(NSError *error) {
        [_smsAlertView showErrorMessage:[error domain]];
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"show_alert",@"1",@"show_loading", nil]];
}

#pragma mark -------------- delegate --------------------------------------

#pragma mark - PierCountryCodeControllerDelegate
- (void)countryCodeWithCountry:(CountryModel *)country
{
    self.country = country;
    // 根据countryCode来限制字数
    self.phoneNumberLabel.text = @"";
    [self checkCountryCodeWithCountry:self.country phoneNumber:self.phoneNumberLabel.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string) {
        if (![string isNumString] && ![NSString emptyOrNull:string]) {
            return NO;
        }
    }

    NSInteger phone_size = [self.country.phone_size integerValue];
 
    NSString * toBeString = [[textField.text stringByReplacingCharactersInRange:range withString:string]  phoneClearFormat];
    
    if (toBeString.length >= phone_size && range.length != 1){
        textField.text = [[toBeString substringToIndex:phone_size] phoneFormat];
        return NO;
    }else {
        textField.text = [textField.text phoneClearFormat];
        return YES;
    }
}

#pragma mark --------------------- 功能函数 ------------------------------
// 检查号码长度
- (BOOL)checkPhone
{
    BOOL result = NO;
    NSString *phone = self.phone;
    if (phone.length == [self.country.phone_size integerValue]) {
        result = YES;
    }else {
        [PIRViewUtil shakeView:self.phoneNumberLabel];
        result = NO;
    }
    return result;
}

// 根据countryCode限定长度
- (void)checkCountryCodeWithCountry:(CountryModel *)country phoneNumber:(NSString *)phoneNumber
{
    NSString *phone_prefix = [NSString stringWithFormat:@"+%@",country.phone_prefix];
    [self.countryCodeButton setTitle:phone_prefix forState:UIControlStateNormal];
    
    if (phoneNumber.length > [country.phone_size integerValue]) {
        self.phoneNumberLabel.text = [phoneNumber substringToIndex:[country.phone_size integerValue]];
    }
}

#pragma mark ------------------ 退出清空 ----------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ---------------------------- PierSMSInputAlertView ----------------------------

- (void)userApprove:(NSString *)userInput{
    [self serviceSMSActivation:userInput];
}
@end
