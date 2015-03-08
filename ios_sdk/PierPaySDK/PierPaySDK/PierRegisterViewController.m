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
#import "PierCreditApplyController.h"
#import "PIRDataSource.h"

@interface PierRegisterViewController ()

@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextField *passwordLabel;
@property (nonatomic, weak) IBOutlet UIView *textRemarkLabel;

@end

@implementation PierRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.passwordLabel becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.passwordLabel resignFirstResponder];
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
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)userSetPasswordAction:(id)sender{
    NSString *password = self.passwordLabel.text;
    [self serviceUserRegister:password];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
