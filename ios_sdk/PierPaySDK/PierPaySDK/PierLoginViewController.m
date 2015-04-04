//
//  PierLoginViewController.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierLoginViewController.h"
#import "PierAlertView.h"
#import "PierKeyboard.h"
#import "PierService.h"
#import "PierTools.h"
#import "PierColor.h"
#import "NSString+PierCheck.h"
#import "PierViewUtil.h"
#import "PierPayService.h"
#import "PierCountryCodeViewController.h"
#import "PierDataSource.h"
#import "PierFont.h"
#import "PierWebViewController.h"

@interface PierLoginViewController ()<PierCountryCodeViewControllerDelegate, UITextFieldDelegate, PierPayServiceDelegate>

@property (nonatomic, weak) IBOutlet UITextField *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordLabel;
@property (nonatomic, weak) IBOutlet UILabel *errorMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel *textRemarkLabel;
@property (nonatomic, weak) IBOutlet UILabel *rememberPwdLabel;
@property (nonatomic, weak) IBOutlet UILabel *countryCodeTitleLabel;

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UIButton *forgetPassword;

@property (nonatomic, weak) IBOutlet UIButton *countryCodeButton;

@property (nonatomic, weak) IBOutlet UISwitch *rememberSwitchBtn;

@property (nonatomic, strong) PierCountryModel *country;
/** servire model */
@property (nonatomic, strong) PierTransactionSMSRequest *smsRequestModel;

@end

@implementation PierLoginViewController
#pragma mark - -------------------- System -------------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _smsRequestModel = [[PierTransactionSMSRequest alloc] init];
      
        _country = [[PierCountryModel alloc]init];
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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneNumberLabel resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)initData
{
//#warning  ---------------- 硬编码 -----------------------
    NSString *phone = [NSString getUnNilString:[__pierDataSource getPhone]];
    NSString *countryCode = [NSString getUnNilString:[__pierDataSource getCountryCode]];
    NSString *password = [NSString getUnNilString:[__pierDataSource getPassword]];
    
    if (![NSString emptyOrNull:phone]) {
        [__pierDataSource.merchantParam setValue:phone forKey:DATASOURCES_PHONE];
    }
    
    if ([NSString emptyOrNull:countryCode]) { //如果userdata中没有存储CountryCode，用商家带来的
        countryCode = [__pierDataSource.merchantParam objectForKey:DATASOURCES_COUNTRY_CODE];
    }
    
    self.country.country_code = countryCode;
    if ([countryCode isEqualToString:@"US"]) {
        self.country.phone_prefix = @"1";
        self.country.phone_size = @"10";
        self.country.name  = @"UNITED STATES";
    }else if ([countryCode isEqualToString:@"CN"]) {
        self.country.phone_prefix = @"86";
        self.country.phone_size = @"11";
        self.country.name  = @"CHINA";
    }else{
        self.country.phone_prefix = @"1";
        self.country.phone_size = @"10";
        self.country.name  = @"UNITED STATES";
    }
    
    [__pierDataSource.merchantParam setValue:countryCode forKey:DATASOURCES_COUNTRY_CODE];
    
    [self checkCountryCodeWithCountry:self.country phoneNumber:self.phoneNumberLabel.text];
    
    NSString *formatePhone = [phone phoneFormat];
//    NSString *formatePhone = [[__pierDataSource.merchantParam objectForKey:@"phone"] phoneFormat];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                         [__pierDataSource.merchantParam objectForKey:@"phone"], pier_userdefaults_phone,
//                         countryCode, pier_userdefaults_countrycode,nil];
//    NSString *password = [__pierDataSource getPassword:dic];
    
    [self.phoneNumberLabel setText:formatePhone];

    if (![NSString emptyOrNull:formatePhone]) {
        if (![NSString emptyOrNull:password]) {
            [self.passwordLabel setText:password];
        }
        [self.passwordLabel becomeFirstResponder];
    }else{
        [self.phoneNumberLabel becomeFirstResponder];
    }
}

- (void)initView
{
    [self.submitButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *submitbtnImg = [PierViewUtil getImageByView:self.submitButton];
    [self.submitButton setBackgroundImage:submitbtnImg forState:UIControlStateNormal];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:5];
    
    [self.phoneNumberLabel setTintColor:[PierColor lightPurpleColor]];
    self.phoneNumberLabel.delegate = self;
    
    [self.passwordLabel setTintColor:[PierColor lightPurpleColor]];
    
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
//    [self.bacButton setContentMode:UIViewContentModeCenter];
//    [self.bacButton setImageEdgeInsets:UIEdgeInsetsMake(6.5, 6.5, 6.5, 6.5)];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    /** remember switch button */
    [self.rememberSwitchBtn setOnTintColor:[PierColor lightPurpleColor]];
    [self.rememberSwitchBtn setThumbTintColor:[PierColor lightGreenColor]];
    [self.rememberSwitchBtn setOn:YES];
    
    /** init fount */
    [self.phoneNumberLabel setFont:[PierFont customFontWithSize:25]];
    [self.passwordLabel setFont:[PierFont customFontWithSize:25]];
    [self.errorMessageLabel setFont:[PierFont customFontWithSize:12]];
    [self.textRemarkLabel setFont:[PierFont customFontWithSize:13]];
    [self.rememberPwdLabel setFont:[PierFont customFontWithSize:10]];
    [self.countryCodeTitleLabel setFont:[PierFont customFontWithSize:10]];
    [self.countryCodeButton.titleLabel setFont:[PierFont customFontWithSize:21]];
    [self.submitButton.titleLabel setFont:[PierFont customFontWithSize:20]];
    [self.forgetPassword.titleLabel setFont:[PierFont customBoldFontWithSize:12]];
}

#pragma mark --------------------- Button Action -------------------------------

#pragma mark - bacButton Action
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - submitButton Action
- (IBAction)submitPhoneAndPwd
{
    NSString *phoneNumber = [self.phoneNumberLabel.text phoneClearFormat];
    if ([self checkPhone:phoneNumber]) {
        NSString *passWord = self.passwordLabel.text;
        self.smsRequestModel.phone = phoneNumber;
        self.smsRequestModel.password = passWord;
        self.smsRequestModel.amount = [__pierDataSource.merchantParam objectForKey:DATASOURCES_AMOUNT];
        self.smsRequestModel.currency_code = [__pierDataSource.merchantParam objectForKey:DATASOURCES_CURRENCY];
        self.smsRequestModel.merchant_id = [__pierDataSource.merchantParam objectForKey:DATASOURCES_MERCHANT_ID];
        [__pierDataSource.merchantParam setObject:phoneNumber forKeyedSubscript:DATASOURCES_PHONE];
        BOOL remember = YES;
        if (self.rememberSwitchBtn.isOn) {
            remember = YES;
        }else{
            remember = NO;
        }
        PierPayService *pierService = [[PierPayService alloc] init];
        pierService.delegate = self;
        pierService.smsRequestModel = self.smsRequestModel;
        [pierService serviceGetPaySMS:remember payWith:ePierPayWith_Merchant];
    }
}

- (IBAction)forgetPassword:(id)sender{
    PierWebViewController *forgetPassword = [[PierWebViewController alloc] initWithNibName:@"PierWebViewController" bundle:pierBoundle()];
    forgetPassword.url = @"http://pierup.ddns.net:8686/umsite/index.html#/userForgetPassword";
    forgetPassword.title = @"Forget Password";
    [self.navigationController pushViewController:forgetPassword animated:NO];
}

#pragma mark - ------------------------ PierPayServiceDelegate ------------------------

- (void)pierPayServiceComplete:(NSDictionary *)result
{
    // Return to Merchant APP
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [__pierDataSource.pierDelegate payWithPierComplete:result];
    }];
}

- (void)pierPayServiceFailed:(NSError *)error
{
    [self.errorMessageLabel setText:[error domain]];
}


#pragma mark - countryCodeButton Action
- (IBAction)countryCodeButtonAction:(UIButton *)sender
{
    
    PierCountryCodeViewController *countryCodeController = [[PierCountryCodeViewController alloc]initWithNibName:@"PierCountryCodeViewController" bundle:pierBoundle()];
    countryCodeController.selectedCountryModel = self.country;
    countryCodeController.delegate = self;
   //默认选中
    
    UINavigationController *countryNav = [[UINavigationController alloc] initWithRootViewController:countryCodeController];
    [self presentViewController:countryNav animated:YES completion:^{
        [self.navigationController setNavigationBarHidden:YES];
    }];
}

#pragma mark ------------------- Delegate --------------------------------------

#pragma mark - PierCountryCodeControllerDelegate
- (void)countryCodeWithCountry:(PierCountryModel *)country
{
    if (![self.country.name isEqualToString:country.name]) {
        self.country = country;
        self.phoneNumberLabel.text = @"";
    }
    [__pierDataSource.merchantParam setObject:country.country_code forKeyedSubscript:DATASOURCES_COUNTRY_CODE];
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

    NSString *toBeString = [[textField.text stringByReplacingCharactersInRange:range withString:string] phoneClearFormat];
    
    if (toBeString.length >= phone_size && range.length != 1){
        textField.text = [[toBeString substringToIndex:phone_size] phoneFormat];
        return NO;
    }else {
         textField.text = [textField.text phoneClearFormat];
        return YES;
    }
}

#pragma mark --------------------- 功能函数 ------------------------------

- (BOOL)checkPhone:(NSString *)phoneNumber
{
        BOOL result = NO;
        NSString *phone = phoneNumber;
        if (phone.length == [self.country.phone_size integerValue]) {
            result = YES;
        }else {
            [PierViewUtil shakeView:self.phoneNumberLabel];
            result = NO;
        }
        return result;
}

- (void)checkCountryCodeWithCountry:(PierCountryModel *)country phoneNumber:(NSString *)phoneNumber
{
    NSString *phone_prefix = [NSString stringWithFormat:@"+%@",country.phone_prefix];
    [self.countryCodeButton setTitle:phone_prefix forState:UIControlStateNormal];
    
//    if (phoneNumber.length > [country.phone_size integerValue]) {
//        self.phoneNumberLabel.text = [phoneNumber substringToIndex:[country.phone_size integerValue]];
//    }
}

#pragma mark -------------------- 退出清空 -----------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
