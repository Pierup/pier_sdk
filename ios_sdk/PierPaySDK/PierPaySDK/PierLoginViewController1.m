//
//  PierLoginViewController.m
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierLoginViewController1.h"
#import "PierAlertView.h"
#import "PierKeyboard.h"
#import "PierService.h"
#import "PierTools.h"
#import "PierColor.h"
#import "NSString+PierCheck.h"
#import "PierViewUtil.h"
//#import "PierPayModel.h"

@interface PierLoginViewController1 ()<PierKeyboardDelegate>

@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UIView *sepLine;
@property (nonatomic, weak) IBOutlet UIView *textRemarkLabel;
/** keyboard */
@property (nonatomic, strong) PierKeyboard *pirKeyBoard;

/** servire model */
@property (nonatomic, strong) TransactionSMSRequest *smsRequestModel;
@property (nonatomic, strong) GetAuthTokenV2Request *loginRequestModel;

@end

@implementation PierLoginViewController1

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _smsRequestModel = [[TransactionSMSRequest alloc] init];
        _loginRequestModel = [[GetAuthTokenV2Request alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)initView{
    self.pirKeyBoard = [PierKeyboard getKeyboardWithType:keyboardTypeNormal alpha:1 delegate:self];
    [self.view addSubview:self.pirKeyBoard];
    [self.pirKeyBoard setFrame:CGRectMake(0, DEVICE_HEIGHT-self.pirKeyBoard.frame.size.height, self.pirKeyBoard.frame.size.width, self.pirKeyBoard.frame.size.height)];
    [self.submitButton setBackgroundColor:[PierColor darkPurpleColor]];
    [self.submitButton setFrame:CGRectMake(0,
                                           self.pirKeyBoard.frame.origin.y-self.submitButton.bounds.size.height-0.5,
                                           DEVICE_WIDTH,
                                           self.submitButton.bounds.size.height)];
    
    [self.phoneNumberLabel setTextColor:[PierColor darkPurpleColor]];
    [self.phoneNumberLabel setFrame:CGRectMake(0,
                                               self.submitButton.frame.origin.y-self.phoneNumberLabel.bounds.size.height,
                                               DEVICE_WIDTH,
                                               self.phoneNumberLabel.bounds.size.height)];
    
    [self.sepLine setBackgroundColor:[PierColor darkPurpleColor]];
    [self.sepLine setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 1)];
    [self.phoneNumberLabel addSubview:self.sepLine];
    
    [self.textRemarkLabel setCenter:CGPointMake(DEVICE_WIDTH/2, self.phoneNumberLabel.frame.origin.y/2+20)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPhone:(id)sender{
    if ([self.smsRequestModel.phone length] != 11 && [self.smsRequestModel.phone length] != 10) {
        [PierViewUtil shakeView:self.phoneNumberLabel];
        return;
    }
    
    self.smsRequestModel.country_code = @"CN";
    
//    [PierService serverSend:ePIER_API_TRANSACTION_SMS resuest:self.smsRequestModel successBlock:^(id responseModel) {
//        [PierCustomKeyboardAlertView showPierAlertView:self param:nil type:ePierAlertViewType_userInput approve:^(NSString *userInput) {
//            self.loginRequestModel.country_code = @"CN";
//            self.loginRequestModel.code = userInput;
//            self.loginRequestModel.merchant_id = @"MC0000000017";
//            self.loginRequestModel.amount = @"199.00";
//            self.loginRequestModel.currency_code = @"USD";
//            [PierService serverSend:ePIER_API_GET_AUTH_TOKEN_V2 resuest:self.loginRequestModel successBlock:^(id responseModel) {
//                
//            } faliedBlock:^(NSError *error) {
//                
//            }];
//        } cancel:^{
//            
//        }];
//    } faliedBlock:^(NSError *error) {
//        
//    }];
}

#pragma mark - -----------------PierKeyboardDelegate---------------

- (void)numberKeyboardInput:(NSString *)number{
    
}

- (void)numberKeyboardAllInput:(NSString *)number{
    self.loginRequestModel.phone = number;
    self.smsRequestModel.phone = number;
    self.phoneNumberLabel.text = number;
    //做字符转换
    if (number.length == 11 || number.length == 10) {  //做字符转换
        self.phoneNumberLabel.text = [number phoneFormat];
    }
}

- (void)numberKeyboardBackspace:(NSString *)number{
    [self.phoneNumberLabel setText:number];
}

@end
