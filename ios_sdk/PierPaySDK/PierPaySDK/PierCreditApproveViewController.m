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
#import "PIRDataSource.h"
#import "PierPayService.h"

@interface PierCreditApproveViewController ()

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *creditLimitLabel;
@property (nonatomic, weak) IBOutlet UILabel *costLabel;
@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic, weak) IBOutlet UIButton *cancleBUtton;

/** servire model */
@property (nonatomic, strong) TransactionSMSRequest *smsRequestModel;
@end

@implementation PierCreditApproveViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _smsRequestModel = [[TransactionSMSRequest alloc] init];
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
    [self.creditLimitLabel setText:self.responseModel.credit_limit];
    [self.costLabel setText:[__dataSource.merchantParam objectForKey:@"amount"]];
    
    [self.payButton setBackgroundColor:[PierColor darkPurpleColor]];
    [self.payButton.layer setMasksToBounds:YES];
    [self.payButton.layer setCornerRadius:5];
    [self.payButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.payButton.layer setBorderWidth:1];
    
    [self.cancleBUtton.layer setMasksToBounds:YES];
    [self.cancleBUtton.layer setCornerRadius:5];
    [self.cancleBUtton.layer setBorderColor:[[PierColor darkPurpleColor] CGColor]];
    [self.cancleBUtton.layer setBorderWidth:1];
}

- (void)initView{
    [self.bgView setBackgroundColor:[PierColor lightPurpleColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)payWithPier{
    self.smsRequestModel.phone = __dataSource.phone;
    PierPayService *pierService = [[PierPayService alloc] init];
    pierService.smsRequestModel = self.smsRequestModel;
    [pierService serviceGetPaySMS];
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
