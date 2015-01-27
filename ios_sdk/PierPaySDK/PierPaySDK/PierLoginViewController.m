//
//  PierLoginViewController.m
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierLoginViewController.h"
#import "PierAlertView.h"
#import "PIRKeyboard.h"
#import "PIRService.h"
//#import "PIRPayModel.h"

@interface PierLoginViewController ()<PIRKeyboardDelegate>

@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
/** keyboard */
@property (nonatomic, strong) PIRKeyboard *pirKeyBoard;

@end

@implementation PierLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView{
    self.pirKeyBoard = [PIRKeyboard getKeyboardWithType:keyboardTypeNormal delegate:self];
    [self.view addSubview:self.pirKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPhone:(id)sender{
    TransactionSMSRequest *requestSMS = [[TransactionSMSRequest alloc] init];
    requestSMS.phone = self.phoneNumberLabel.text;
    requestSMS.country_code = @"CN";
    [PIRService serverSend:ePIER_API_TRANSACTION_SMS resuest:requestSMS successBlock:^(id responseModel) {

    } faliedBlock:^(NSError *error) {
        
    }];
    
    [PIRService serverSend:ePIER_API_TRANSACTION_SMS resuest:requestSMS successBlock:^(id responseModel) {
        [PierAlertView showPierAlertView:self param:nil type:ePierAlertViewType_userInput approve:^(NSString *userInput) {
            GetAuthTokenV2Request *requestModel = [[GetAuthTokenV2Request alloc] init];
            requestModel.phone = @"18638998588";
            requestModel.country_code = @"CN";
            requestModel.code = userInput;
            requestModel.merchant_id = @"MC0000000017";
            requestModel.amount = @"199.00";
            requestModel.currency_code = @"USD";
            [PIRService serverSend:ePIER_API_GET_AUTH_TOKEN_V2 resuest:requestModel successBlock:^(id responseModel) {
                
            } faliedBlock:^(NSError *error) {
                
            }];
        } cancel:^{
            
        }];
    } faliedBlock:^(NSError *error) {
        
    }];
    

}

#pragma mark - -----------------PIRKeyboardDelegate---------------

- (void)numberKeyboardInput:(NSString *)number{
    
}

- (void)numberKeyboardAllInput:(NSString *)number{
    [self.phoneNumberLabel setText:number];
}

- (void)numberKeyboardBackspace:(NSString *)number{
    [self.phoneNumberLabel setText:number];
}

@end
