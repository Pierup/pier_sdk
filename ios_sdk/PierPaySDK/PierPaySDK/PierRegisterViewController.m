//
//  PierRegisterViewController.m
//  PierPaySDK
//
//  Created by zyma on 3/2/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierRegisterViewController.h"
#import "PierService.h"
#import "PierTools.h"
#import "PierColor.h"
#import "NSString+PierCheck.h"
#import "PierViewUtil.h"
#import "PierCreditApplyController.h"
#import "PierDataSource.h"
#import "PierFont.h"

@interface PierRegisterViewController ()

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UILabel *indicateLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordLabel;
@property (nonatomic, weak) IBOutlet UITextField *verificationTextField;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UILabel *errorMessageLabel;

@end

@implementation PierRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.passwordLabel becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.passwordLabel resignFirstResponder];
    [self.verificationTextField resignFirstResponder];
}

- (void)initData
{
    
}

- (void)initView
{
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        
    [self.passwordLabel setTintColor:[PierColor lightPurpleColor]];
    [self.verificationTextField setTintColor:[PierColor lightPurpleColor]];
    
    [self.submitButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *submitbtnImg = [PierViewUtil getImageByView:self.submitButton];
    [self.submitButton setBackgroundImage:submitbtnImg forState:UIControlStateNormal];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:5];
    
    /** Init Fount */
    [self.indicateLabel setFont:[PierFont customFontWithSize:10]];
    [self.passwordLabel setFont:[PierFont customFontWithSize:25]];
    [self.verificationTextField setFont:[PierFont customFontWithSize:25]];
    [self.errorMessageLabel setFont:[PierFont customFontWithSize:12]];
    [self.submitButton.titleLabel setFont:[PierFont customFontWithSize:20]];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)userSetPasswordAction:(id)sender
{
    if ([self checkPasswordAndverifyPassword]) {
        [self serviceUserRegister:self.passwordLabel.text];
    }
}

- (void)serviceUserRegister:(NSString *)password{
    PierRegisterRequest *requestModel = [[PierRegisterRequest alloc] init];
    requestModel.phone = [__pierDataSource.merchantParam objectForKey:DATASOURCES_PHONE];
    requestModel.token = self.token;
    requestModel.password = password;
    
    [PierService serverSend:ePIER_API_GET_ACTIVITION_REGIST resuest:requestModel successBlock:^(id responseModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PierCreditApplyController *registerVC = [[PierCreditApplyController alloc] initWithNibName:@"PierCreditApplyController" bundle:pierBoundle()];
            [self.navigationController pushViewController:registerVC animated:YES];
        });
    } faliedBlock:^(NSError *error) {
        [self showFailedMessageLabel:error];
    } attribute:nil];
}

#pragma mark ------------------ function -------------------------

- (void)showFailedMessageLabel:(NSError *)error
{
    [self.errorMessageLabel setText:[error domain]];
}

- (BOOL)checkPasswordAndverifyPassword
{
    NSString *password = self.passwordLabel.text;
    NSString *verifyPassword = self.verificationTextField.text;
    if (![NSString emptyOrNull:password] && [password isEqualToString:verifyPassword])
    {
        return YES;
    }else {
        [PierViewUtil shakeView:self.passwordLabel];
        [PierViewUtil shakeView:self.verificationTextField];
        return NO;
    }
}

#pragma mark ---------------退出清空 -------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
