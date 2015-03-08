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

@interface PierSiginViewController ()<PierCountryCodeViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UIView *textRemarkLabel;
@property (nonatomic, weak) IBOutlet UIButton *countryCodeButton;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) PierCountryCodeViewController *countryCodeViewController;

@end

@implementation PierSiginViewController

#pragma mark - -------------------- System -----------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.countryCodeViewController = [[PierCountryCodeViewController alloc]initWithNibName:@"PierCountryCodeViewController" bundle:pierBoundle()];
            self.countryCodeViewController.delegate = self;
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
    [self.phoneNumberLabel becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.phoneNumberLabel resignFirstResponder];
}

- (void)initData
{
    
}

- (void)initView
{
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNumberLabel.delegate  = self;
    
    if (self.countryCodeViewController.countryType == eCountryType_US) {
        [self.countryCodeButton setTitle:@"+1" forState:UIControlStateNormal];
    }else if (self.countryCodeViewController.countryType == eCountryType_CHINA){
        [self.countryCodeButton setTitle:@"+86" forState:UIControlStateNormal];
    }
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
    self.phone = [self.phoneNumberLabel text];
    if ([self checkPhone]) {
        [self serviceGetReigistSMS];
    }
}

#pragma makr - countryCodeButton Action
- (IBAction)countryCodeButtonAction:(UIButton *)sender
{
    [self.navigationController presentViewController:self.countryCodeViewController animated:YES completion:^{
        
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
                               @"",@"titleImageName",
                               @"SMS",@"title",
                               @"Next",@"approveText",
                               @"Dismiss",@"cancleText",
                               self.phone,@"phone",
                               response.expiration,@"expirationTime",nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [PierSMSAlertView showPierUserInputAlertView:self param:param type:ePierAlertViewType_userInput approve:^(NSString *userInput) {
                [self serviceSMSActivation:userInput];
            } cancel:^{
                
            }];
        });
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
            PierRegisterViewController *loginPage = [[PierRegisterViewController alloc] initWithNibName:@"PierRegisterViewController" bundle:pierBoundle()];
            loginPage.token = reqponse.token;
            [self.navigationController pushViewController:loginPage animated:NO];
        });
    } faliedBlock:^(NSError *error) {
        
    } attribute:nil];
}

#pragma mark -------------- delegate --------------------------------------

#pragma mark - PierCountryCodeControllerDelegate
- (void)countryCode:(NSString *)countryCode countryName:(NSString *)countryName countryCodeViewController:(PierCountryCodeViewController *)countryCodeViewController
{
    // 根据countryCode来限制字数
    [self checkCountryCode:countryCode countryName:countryName phoneNumber:self.phoneNumberLabel.text];
    [countryCodeViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
- (BOOL)checkPhone
{
    BOOL result = NO;
    NSString *phone = self.phone;
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

#pragma mark ------------------ 退出清空 ----------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
