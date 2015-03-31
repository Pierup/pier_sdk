//
//  PierSiginViewController.m
//  PierPaySDK
//
//  Created by zyma on 3/2/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierSiginViewController.h"
#import "PierService.h"
#import "PierTools.h"
#import "PierColor.h"
#import "NSString+PierCheck.h"
#import "PierRegisterViewController.h"
#import "PierViewUtil.h"
#import "PierAlertView.h"
#import "PierCountryCodeViewController.h"
#import "PierDataSource.h"
#import "PierFont.h"

@interface PierSiginViewController ()<PierCountryCodeViewControllerDelegate, UITextFieldDelegate, PierSMSInputAlertDelegate>

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *textRemarkLabel;
@property (nonatomic, weak) IBOutlet UIButton *countryCodeButton;
@property (nonatomic, weak) IBOutlet UILabel *errorMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel *countryCodeTitleLabel;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, strong) PierCountryModel *country;

@property (nonatomic, strong) PierSMSAlertView *smsAlertView;

@end

@implementation PierSiginViewController

#pragma mark - -------------------- System -----------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    NSString *countryCode = [__pierDataSource.merchantParam objectForKey:DATASOURCES_COUNTRY_CODE];
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
        self.country.country_code = @"US";
        self.country.phone_prefix = @"1";
        self.country.phone_size = @"10";
        self.country.name  = @"UNITED STATES";
    }
    
    [__pierDataSource.merchantParam setValue:self.country.country_code forKey:DATASOURCES_COUNTRY_CODE];
    
    NSString *formatePhone = [[__pierDataSource.merchantParam objectForKey:@"phone"] phoneFormat];
    [self.phoneNumberLabel setText:formatePhone];
    
    [self checkCountryCodeWithCountry:self.country phoneNumber:self.phoneNumberLabel.text];
}

- (void)initView
{
    [self.submitButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *submitbtnImg = [PierViewUtil getImageByView:self.submitButton];
    [self.submitButton setBackgroundImage:submitbtnImg forState:UIControlStateNormal];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:5];

    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.phoneNumberLabel setTintColor:[PierColor lightPurpleColor]];
    self.phoneNumberLabel.delegate  = self;
    
    /** init Fount */
    [self.countryCodeTitleLabel setFont:[PierFont customFontWithSize:10]];
    [self.phoneNumberLabel setFont:[PierFont customFontWithSize:25]];
    [self.textRemarkLabel setFont:[PierFont customFontWithSize:13]];
    [self.countryCodeButton.titleLabel setFont:[PierFont customFontWithSize:21]];
    [self.errorMessageLabel setFont:[PierFont customFontWithSize:12]];
    [self.countryCodeTitleLabel setFont:[PierFont customFontWithSize:10]];
    [self.submitButton.titleLabel setFont:[PierFont customFontWithSize:20]];
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
    [__pierDataSource.merchantParam setObject:self.phone forKeyedSubscript:DATASOURCES_PHONE];
    if ([self checkPhone]) {
        [self serviceGetReigistSMS];
    }
}

#pragma makr - countryCodeButton Action
- (IBAction)countryCodeButtonAction:(UIButton *)sender
{
    PierCountryCodeViewController *countryCodeController = [[PierCountryCodeViewController alloc]initWithNibName:@"PierCountryCodeViewController" bundle:pierBoundle()];
    countryCodeController.selectedCountryModel = self.country;
    countryCodeController.delegate = self;
    
    UINavigationController *countryNav = [[UINavigationController alloc] initWithRootViewController:countryCodeController];
    [self presentViewController:countryNav animated:YES completion:^{
        [self.navigationController setNavigationBarHidden:YES];
    }];
}

#pragma mark - -------------------- 接口API ----------------------------

- (void)serviceGetReigistSMS
{
    PierGetRegisterCodeRequest *requestModel = [[PierGetRegisterCodeRequest alloc] init];
    requestModel.phone = self.phone;
    
    [PierService serverSend:ePIER_API_GET_ACTIVITY_CODE resuest:requestModel successBlock:^(id responseModel) {
        PierGetRegisterCodeResponse *response = (PierGetRegisterCodeResponse *)responseModel;
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"",@"title_image_name",
                               @"Passcode",@"title",
                               @"Next",@"approve_text",
                               @"Dismiss",@"cancle_text",
                               self.phone,@"phone",
                               response.expiration,@"expiration_time",
                               @"6",@"code_length",nil];
        _smsAlertView = [[PierSMSAlertView alloc] initWith:self param:param type:ePierAlertViewType_instance];
        _smsAlertView.delegate = self;
        [_smsAlertView show];
    } faliedBlock:^(NSError *error) {
        [self showFailedMessageLabel:error];
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"show_alert",@"0",@"show_loading", nil]];
}

- (void)rSendServiceReigistSMS
{
    PierGetRegisterCodeRequest *requestModel = [[PierGetRegisterCodeRequest alloc] init];
    requestModel.phone = self.phone;
    
    [PierService serverSend:ePIER_API_GET_ACTIVITY_CODE resuest:requestModel successBlock:^(id responseModel) {
        PierGetRegisterCodeResponse *response = (PierGetRegisterCodeResponse *)responseModel;
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"",@"title_image_name",
                               @"Passcode",@"title",
                               @"Next",@"approve_text",
                               @"Dismiss",@"cancle_text",
                               self.phone,@"phone",
                               response.expiration,@"expiration_time",
                               @"6",@"code_length",nil];
        if (!_smsAlertView) {
            _smsAlertView = [[PierSMSAlertView alloc] initWith:self param:param type:ePierAlertViewType_instance];
            _smsAlertView.delegate = self;
            [_smsAlertView show];
        }else{
            [_smsAlertView refreshTimer:param];
        }
        [_smsAlertView showErrorMessage:@""];
    } faliedBlock:^(NSError *error) {
        [_smsAlertView showErrorMessage:[error domain]];
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"show_alert",@"0",@"show_loading", nil]];
}

- (void)serviceSMSActivation:(NSString *)activation_code
{
    PierRegSMSActiveRequest *requestModel = [[PierRegSMSActiveRequest alloc] init];
    requestModel.phone = self.phone;
    requestModel.activation_code = activation_code;
    
    [PierService serverSend:ePIER_API_GET_ACTIVITION resuest:requestModel successBlock:^(id responseModel) {
        PierRegSMSActiveResponse *reqponse = (PierRegSMSActiveResponse *)responseModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_smsAlertView dismiss];
            PierRegisterViewController *loginPage = [[PierRegisterViewController alloc] initWithNibName:@"PierRegisterViewController" bundle:pierBoundle()];
            loginPage.token = reqponse.token;
            [self.navigationController pushViewController:loginPage animated:NO];
        });
        [_smsAlertView showErrorMessage:@""];
    } faliedBlock:^(NSError *error) {
        [_smsAlertView showErrorMessage:[error domain]];
    } attribute:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"show_alert",@"0",@"show_loading", nil]];
}

#pragma mark -------------- delegate --------------------------------------

#pragma mark - PierCountryCodeControllerDelegate
- (void)countryCodeWithCountry:(PierCountryModel *)country
{
    if (![self.country.name isEqualToString:country.name]) {
        self.country = country;
        self.phoneNumberLabel.text = @"";
    }
    [self checkCountryCodeWithCountry:self.country phoneNumber:self.phoneNumberLabel.text];
    [__pierDataSource.merchantParam setObject:country.country_code forKeyedSubscript:DATASOURCES_COUNTRY_CODE];
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

- (void)showFailedMessageLabel:(NSError *)error
{
    [self.errorMessageLabel setText:[error domain]];
}


- (BOOL)checkPhone
{
    BOOL result = NO;
    NSString *phone = self.phone;
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

- (void)userCancel{
    //User Cancel Register.
//    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"1",@"status",
//                            @"Payment Cancel",@"message", nil];
//    [__pierDataSource.pierDelegate payWithPierComplete:result];
}

- (void)resendTextMessage{
    //resend register text message
    [self rSendServiceReigistSMS];
}

@end
