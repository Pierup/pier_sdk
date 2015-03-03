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

@interface PierSiginViewController ()

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UIView *textRemarkLabel;

@property (nonatomic, copy) NSString *phone;

@end

@implementation PierSiginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.phoneNumberLabel becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.phoneNumberLabel resignFirstResponder];
}

- (void)initData{
    
}

- (void)initView{
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userRegisterAction:(id)sender{
    self.phone = [self.phoneNumberLabel text];
    if ([self checkPhone]) {
        [self serviceGetReigistSMS];
    }
}

- (void)serviceGetReigistSMS{
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
        
    }];
}

- (void)serviceSMSActivation:(NSString *)activation_code{
    RegSMSActiveRequest *requestModel = [[RegSMSActiveRequest alloc] init];
    requestModel.phone = self.phone;
    requestModel.activation_code = activation_code;
    
    [PIRService serverSend:ePIER_API_GET_ACTIVITION resuest:requestModel successBlock:^(id responseModel) {
        RegSMSActiveResponse *reqponse = (RegSMSActiveResponse *)responseModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            PierRegisterViewController *loginPage = [[PierRegisterViewController alloc] initWithNibName:@"PierRegisterViewController" bundle:pierBoundle()];
            loginPage.token = reqponse.token;
            [self.navigationController pushViewController:loginPage animated:YES];
        });
    } faliedBlock:^(NSError *error) {
        
    }];
}

- (BOOL)checkPhone{
    BOOL result = NO;
    NSString *phone = self.phone;
    if (phone.length == 10 || phone.length == 11) {
        result = YES;
    }else{
        [PIRViewUtil shakeView:self.phoneNumberLabel];
        result = NO;
    }
    return result;
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
