//
//  PierRegisterViewController.m
//  PierPaySDK
//
//  Created by zyma on 3/2/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierRegisterViewController.h"
#import "PIRService.h"
#import "PierTools.h"
#import "PierColor.h"
#import "NSString+Check.h"
#import "PIRViewUtil.h"
#import "PierCreditApplyController.h"
#import "PIRDataSource.h"

@interface PierRegisterViewController ()

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UILabel *indicateLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordLabel;
@property (nonatomic, weak) IBOutlet UITextField *verificationTextField;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@end

@implementation PierRegisterViewController

- (void)viewDidLoad {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData{
    
}

- (void)initView{
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.indicateLabel.textColor = [PierColor lightGreenColor];
    
    [self.passwordLabel setTintColor:[PierColor lightPurpleColor]];
    [self.verificationTextField setTintColor:[PierColor lightPurpleColor]];
    
    [self.submitButton setBackgroundColor:[PierColor darkPurpleColor]];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:5];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)userSetPasswordAction:(id)sender
{
    if ([self checkPasswordAndverifyPassword]) {
        [self serviceUserRegister:self.passwordLabel.text];
    }
}

- (void)serviceUserRegister:(NSString *)password{
    RegisterRequest *requestModel = [[RegisterRequest alloc] init];
    requestModel.phone = __dataSource.phone;
    requestModel.token = self.token;
    requestModel.password = password;
    
    [PIRService serverSend:ePIER_API_GET_ACTIVITION_REGIST resuest:requestModel successBlock:^(id responseModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PierCreditApplyController *registerVC = [[PierCreditApplyController alloc] initWithNibName:@"PierCreditApplyController" bundle:pierBoundle()];
            [self.navigationController pushViewController:registerVC animated:YES];
        });
    } faliedBlock:^(NSError *error) {
        
    } attribute:nil];
}

#pragma mark ------------------ function -------------------------
- (BOOL)checkPasswordAndverifyPassword
{
    NSString *password = self.passwordLabel.text;
    NSString *verifyPassword = self.verificationTextField.text;
    if (![NSString emptyOrNull:password] && ![NSString emptyOrNull:verifyPassword] && [password isEqualToString:verifyPassword]) {
        return YES;
    }else {
        [PIRViewUtil shakeView:self.passwordLabel];
        [PIRViewUtil shakeView:self.verificationTextField];
        return NO;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
