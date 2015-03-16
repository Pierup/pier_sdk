//
//  PierLoginViewController.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierLoginViewController.h"
#import "PierAlertView.h"
#import "PIRKeyboard.h"
#import "PIRService.h"
#import "PierTools.h"
#import "PierColor.h"
#import "NSString+Check.h"
#import "PIRViewUtil.h"
#import "PierPayService.h"
#import "PierCountryCodeViewController.h"
#import "PIRDataSource.h"

@interface PierLoginViewController ()<PierCountryCodeViewControllerDelegate, UITextFieldDelegate, PierPayServiceDelegate>

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordLabel;
@property (nonatomic, weak) IBOutlet UIView *textRemarkLabel;
@property (nonatomic, weak) IBOutlet UIButton *countryCodeButton;

@property (nonatomic, strong) PierCountryCodeViewController *countryCodeViewController;
@property (nonatomic, strong) CountryModel *country;
/** servire model */
@property (nonatomic, strong) TransactionSMSRequest *smsRequestModel;

@end

@implementation PierLoginViewController
#pragma mark - -------------------- System -------------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _smsRequestModel = [[TransactionSMSRequest alloc] init];
        // 初始化countryCodeViewController
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneNumberLabel resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)initData
{
#warning  ---------------- 硬编码 -----------------------
    NSString *countryCode = __dataSource.country_code;
    self.country.country_code = countryCode;
    if ([countryCode isEqualToString:@"US"]) {
        self.country.phone_prefix = @"1";
        self.country.phone_size = @"10";
        self.country.name  = @"UNITED STATES";
    }
    [self checkCountryCodeWithCountry:self.country phoneNumber:self.phoneNumberLabel.text];
}


- (void)initView
{
    [self.submitButton setBackgroundColor:[PierColor darkPurpleColor]];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:5];
    
    [self.phoneNumberLabel setTintColor:[PierColor lightPurpleColor]];
    self.phoneNumberLabel.delegate = self;
    
    [self.passwordLabel setTintColor:[PierColor lightPurpleColor]];
    
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark --------------------- Button Action -------------------------------

#pragma mark - bacButton Action
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - submitButton Action
- (IBAction)submitPhoneAndPwd{
    NSString *phoneNumber = self.phoneNumberLabel.text;
    if ([self checkPhone:phoneNumber]) {
        NSString *passWord = self.passwordLabel.text;
        self.smsRequestModel.phone = phoneNumber;
        self.smsRequestModel.password = passWord;
        
        PierPayService *pierService = [[PierPayService alloc] init];
        pierService.delegate = self;
        pierService.smsRequestModel = self.smsRequestModel;
        [pierService serviceGetPaySMS];
    }
}

#pragma mark - ------------------------ PierPayServiceDelegate ------------------------

- (void)pierPayServiceComplete:(NSDictionary *)result{
    // Return to Merchant APP
    [__dataSource.pierDelegate payByPierComplete:result];
}


#pragma mark - countryCodeButton Action
- (IBAction)countryCodeButtonAction:(UIButton *)sender {
    UINavigationController *countryNav = [[UINavigationController alloc] initWithRootViewController:self.countryCodeViewController];
    [self presentViewController:countryNav animated:YES completion:^{
        [self.navigationController setNavigationBarHidden:YES];
    }];
}

#pragma mark ------------------- Delegate --------------------------------------

#pragma mark - PierCountryCodeControllerDelegate
- (void)countryCodeWithCountry:(CountryModel *)country
{
    self.country = country;
    // 根据countryCode来限制字数
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

    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //限制位数
    
    //根据位数格式化
//    if (toBeString.length == phone_size) {
//        textField.text = [toBeString phoneFormat];
//    }else {
//        textField.text = [toBeString phoneClearFormat];
//    }
    if (toBeString.length > phone_size && range.length != 1){
        return NO;
    }else {
         textField.text = [textField.text phoneClearFormat];
        return YES;
    }
}

#pragma mark --------------------- 功能函数 ------------------------------

// 检查号码长度
- (BOOL)checkPhone:(NSString *)phoneNumber
{
        BOOL result = NO;
        NSString *phone = phoneNumber;
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

#pragma mark -------------------- 退出清空 -----------------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
