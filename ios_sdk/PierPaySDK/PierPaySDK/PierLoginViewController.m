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

@interface PierLoginViewController ()<PierCountryCodeViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordLabel;
@property (nonatomic, weak) IBOutlet UIView *textRemarkLabel;
@property (nonatomic, weak) IBOutlet UIButton *countryCodeButton;

@property (nonatomic, strong) PierCountryCodeViewController *countryCodeViewController;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

- (void)initView
{
    [self.submitButton setBackgroundColor:[PierColor darkPurpleColor]];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:5];
    
    [self.phoneNumberLabel setTextColor:[PierColor darkPurpleColor]];
    [self.phoneNumberLabel becomeFirstResponder];
    
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
     self.phoneNumberLabel.delegate = self;
    
    if (self.countryCodeViewController.countryType == eCountryType_US) {
        [self.countryCodeButton setTitle:@"+1" forState:UIControlStateNormal];
    }else if (self.countryCodeViewController.countryType == eCountryType_CHINA){
        [self.countryCodeButton setTitle:@"+86" forState:UIControlStateNormal];
    }
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
        pierService.smsRequestModel = self.smsRequestModel;
        [pierService serviceGetPaySMS];
    }
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
- (void)countryCode:(NSString *)countryCode countryName:(NSString *)countryName countryCodeViewController:(PierCountryCodeViewController *)countryCodeViewController
{
    // 根据countryCode来限制字数
    [self checkCountryCode:countryCode countryName:countryName phoneNumber:self.phoneNumberLabel.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.countryCodeViewController.countryType == eCountryType_CHINA) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
        return YES;
    }else if (self.countryCodeViewController.countryType == eCountryType_US){
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 10 && range.length!=1){
            textField.text = [toBeString substringToIndex:10];
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
}

#pragma mark --------------------- 功能函数 ------------------------------

// 检查号码长度
- (BOOL)checkPhone:(NSString *)phoneNumber
{
    BOOL result = NO;
    NSString *phone = phoneNumber;
    if (self.countryCodeViewController.countryType == eCountryType_US && phone.length == 10) {
        result = YES;
    }else if (self.countryCodeViewController.countryType == eCountryType_CHINA && phone.length == 11){
        result = YES;
    }
    else{
        [PIRViewUtil shakeView:self.phoneNumberLabel];
        result = NO;
    }
    return result;
}

// 根据countryCode限定长度
- (void)checkCountryCode:(NSString *)countryCode countryName:(NSString *)countryName phoneNumber:(NSString *)phoneNumber
{
    if ([countryName isEqualToString:@"CHINA"]) {
        self.countryCodeViewController.countryType = eCountryType_CHINA;
        [self.countryCodeButton setTitle:countryCode forState:UIControlStateNormal];
    }else if([countryName isEqualToString:@"US"]){
        if (phoneNumber.length > 10) {
            self.phoneNumberLabel.text = [phoneNumber substringToIndex:10];
        }
        self.countryCodeViewController.countryType = eCountryType_US;
        [self.countryCodeButton setTitle:countryCode forState:UIControlStateNormal];
    }
}

#pragma mark -------------------- 退出清空 -----------------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
