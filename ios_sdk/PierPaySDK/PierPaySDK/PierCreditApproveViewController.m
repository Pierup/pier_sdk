//
//  PierCreditApproveViewController.m
//  PierPaySDK
//
//  Created by zyma on 3/3/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierCreditApproveViewController.h"
#import "PierColor.h"
#import "PierTools.h"
#import "PierDataSource.h"
#import "PierPayService.h"
#import "NSString+PierCheck.h"
#import "PierViewUtil.h"

@interface PierCreditApproveViewController () <PierPayServiceDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *creditLimitLabel;
@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic, weak) IBOutlet UIButton *cancleButton;

/** servire model */
@property (nonatomic, strong) PierTransactionSMSRequest *smsRequestModel;
@end

@implementation PierCreditApproveViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _smsRequestModel = [[PierTransactionSMSRequest alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

- (void)initData{
    NSString *credtiLimit_currency = [NSString getNumberFormatterDecimalStyle:self.responseModel.credit_limit currency:self.responseModel.currency];
    [self.creditLimitLabel setText:credtiLimit_currency];
    
    [self.payButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *payButtonImg = [PierViewUtil getImageByView:self.payButton];
    [self.payButton setBackgroundImage:payButtonImg forState:UIControlStateNormal];
    [self.payButton.layer setMasksToBounds:YES];
    [self.payButton.layer setCornerRadius:5];
//    [self.payButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
//    [self.payButton.layer setBorderWidth:1];
    
    [self.cancleButton.layer setMasksToBounds:YES];
    [self.cancleButton.layer setCornerRadius:5];
    [self.cancleButton.layer setBorderColor:[[PierColor darkPurpleColor] CGColor]];
    [self.cancleButton.layer setBorderWidth:1];
}

- (void)initView{
    NSString *amount = [NSString getNumberFormatterDecimalStyle:[__dataSource.merchantParam objectForKey:DATASOURCES_AMOUNT] currency:[__dataSource.merchantParam objectForKey:DATASOURCES_CURRENCY]];
    [self.payButton setTitle:[NSString stringWithFormat:@"Pay %@ with Pier",amount] forState:UIControlStateNormal];
    
    UIImage *patBtnImg = [PierViewUtil getImageByView:self.payButton];
    [self.payButton setBackgroundImage:patBtnImg forState:UIControlStateNormal];
    
    UIImage *cancleBtnView = [PierViewUtil getImageByView:self.cancleButton];
    [self.cancleButton setBackgroundImage:cancleBtnView forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payWithPier{
    self.smsRequestModel.phone = [__dataSource.merchantParam objectForKey:DATASOURCES_PHONE];
    PierPayService *pierService = [[PierPayService alloc] init];
    pierService.delegate = self;
    pierService.smsRequestModel = self.smsRequestModel;
    [pierService serviceGetPaySMS:YES];
}

- (IBAction)cancelPay:(id)sender{
    // Return to Merchant APP
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [__dataSource.pierDelegate payWithPierComplete:nil];
    }];
}

#pragma mark - ------------------------ PierPayServiceDelegate ------------------------

- (void)pierPayServiceComplete:(NSDictionary *)result{
    // Return to Merchant APP
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [__dataSource.pierDelegate payWithPierComplete:result];
    }];
}

- (void)pierPayServiceFailed:(NSError *)error{
    
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
