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

@interface PierLoginViewController ()

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UITextField *passwordLabel;
@property (nonatomic, weak) IBOutlet UIView *textRemarkLabel;

/** servire model */
@property (nonatomic, strong) TransactionSMSRequest *smsRequestModel;

@end

@implementation PierLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _smsRequestModel = [[TransactionSMSRequest alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}

- (void)initView{
    [self.submitButton setBackgroundColor:[PierColor darkPurpleColor]];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setCornerRadius:5];
    
    [self.phoneNumberLabel setTextColor:[PierColor darkPurpleColor]];
    [self.phoneNumberLabel becomeFirstResponder];
    
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitPhoneAndPwd{
    NSString *phoneNumber = self.phoneNumberLabel.text;
    NSString *passWord = self.passwordLabel.text;
    self.smsRequestModel.phone = phoneNumber;
    self.smsRequestModel.password = passWord;
    
    PierPayService *pierService = [[PierPayService alloc] init];
    pierService.smsRequestModel = self.smsRequestModel;
    [pierService serviceGetPaySMS];
}

//- (void)serviceGetPaySMS{
//    [PIRService serverSend:ePIER_API_TRANSACTION_SMS resuest:self.smsRequestModel successBlock:^(id responseModel) {
//        TransactionSMSResponse *response = (TransactionSMSResponse *)responseModel;
//        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
//                               @"",@"titleImageName",
//                               @"SMS",@"title",
//                               @"Pay",@"approveText",
//                               @"Cancel",@"cancleText",
//                               self.smsRequestModel.phone,@"phone",
//                               response.expiration,@"expirationTime",nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [PierSMSAlertView showPierUserInputAlertView:self param:param type:ePierAlertViewType_userInput approve:^(NSString *userInput) {
//                [self serviceGetAuthToken:userInput];
//            } cancel:^{
//                
//            }];
//        });
//    } faliedBlock:^(NSError *error) {
//        
//    }];
//}
//
//- (void)serviceGetAuthToken:(NSString *)userinput{
//    self.authTokenRequestModel.phone = __dataSource.phone;
//    self.authTokenRequestModel.pass_code = userinput;
//    self.authTokenRequestModel.pass_type = @"1";
//    self.authTokenRequestModel.merchant_id = [__dataSource.merchantParam objectForKey:@"merchant_id"];
//    self.authTokenRequestModel.amount = [__dataSource.merchantParam objectForKey:@"amount"];
//    self.authTokenRequestModel.currency_code = [__dataSource.merchantParam objectForKey:@"currency"];
//    
//    [PIRService serverSend:ePIER_API_GET_AUTH_TOKEN_V2 resuest:self.authTokenRequestModel successBlock:^(id responseModel) {
//        GetAuthTokenV2Response *response = (GetAuthTokenV2Response *)responseModel;
//        [self serviceMerchantService:response];
//    } faliedBlock:^(NSError *error) {
//        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
//                                @"1",@"status",
//                                [error domain],@"message", nil];
//        [self pierPayComplete:result];
//    }];
//}
//
//- (void)serviceMerchantService:(GetAuthTokenV2Response *)resultModel{
//    MerchantRequest *requestModel = [[MerchantRequest alloc] init];
//    requestModel.auth_token = resultModel.auth_token;
//    [PIRService serverSend:ePIER_API_GET_MERCHANT resuest:requestModel successBlock:^(id responseModel) {
//        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
//                                @"0",@"status",
//                                @"success",@"message", nil];
//        [self pierPayComplete:result];
//    } faliedBlock:^(NSError *error) {
//        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
//                                @"1",@"status",
//                                [error domain],@"message", nil];
//        [self pierPayComplete:result];
//    }];
//}
//
///**
// * pay by pier conmpete!
// */
//- (void)pierPayComplete:(NSDictionary *)result{
//    [__dataSource.pierDelegate payByPierComplete:result];
//}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
