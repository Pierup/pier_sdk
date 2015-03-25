//
//  PierSiginViewController.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierCreditApplyController.h"
#import "PierSiginViewModel.h"
#import "PierTools.h"
#import "PierService.h"
#import "PierPayModel.h"
#import "PierCreditApproveViewController.h"

@interface PierCreditApplyController ()<PierSiginCellsDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *bacButton;
@property (nonatomic, weak) IBOutlet UIButton *helpButton;
@property (nonatomic, strong) PierSiginViewModel *infoViewModel;
@property (nonatomic, strong) PierSiginCellModel *cellModel;

@end

@implementation PierCreditApplyController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _infoViewModel = [[PierSiginViewModel alloc] init];
        _infoViewModel.cellDelegate = self;
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
    if (self.model) {
        [self serviceUserUpload];
    }
}

- (void)initView{
    [self.bacButton setBackgroundColor:[UIColor clearColor]];
    [self.bacButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"backpueple")] forState:UIControlStateNormal];
    [self.bacButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.helpButton setBackgroundColor:[UIColor clearColor]];
    [self.helpButton setBackgroundImage:[UIImage imageWithContentsOfFile:getImagePath(@"sdk-help")] forState:UIControlStateNormal];

    [_infoViewModel createTableData];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------------代理方法--------------------

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *key = [[self.infoViewModel.sectionArray[section] allKeys] firstObject];
    NSArray *cells = [self.infoViewModel.sectionArray[section] objectForKey:key];
    return [cells count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.infoViewModel.sectionArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.infoViewModel heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.infoViewModel getIdentifierByCellIndex:indexPath];
    PierSiginCells *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [self.infoViewModel cellForRowAtIndexPath:indexPath];
    }
    [self.infoViewModel configCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        PierSiginCells *cell = [self.infoViewModel footViewForRowAtSection:section];
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 60)];
//        [footerView addSubview:cell];
//        [footerView setBackgroundColor:[UIColor clearColor]];
//        
//        return footerView;
//    }
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return 104;
//    }else{
//        return 0;
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - PierSiginCellsDelegate

- (void)submitUserInfo{
    if ([self.infoViewModel checkUserInfo]) {
        self.cellModel = [self.infoViewModel getSiginCellModel];
        [self serviceUpdataUser:self.cellModel];
    }
}

#pragma mark ------------------ Service -------------------------

- (void)serviceUserUpload{
    PierGetUserRequest *requestModel = [[PierGetUserRequest alloc] init];
    [PierService serverSend:ePIER_API_GET_GETUSER resuest:requestModel successBlock:^(id responseModel) {
        PierGetUserResponse *response = (PierGetUserResponse *)responseModel;
        [self.infoViewModel setSiginCellModel:response];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } faliedBlock:^(NSError *error) {
    } attribute:nil];
}

- (void)serviceUpdataUser:(PierSiginCellModel *)userModel{
    PierUpdateRequest *requestModel = [[PierUpdateRequest alloc] init];
    requestModel.first_name = userModel.firstName;
    requestModel.last_name = userModel.lastName;
    requestModel.email  =   userModel.email;
    requestModel.dob    =   userModel.dob;
    requestModel.ssn    =   userModel.ssn;
    requestModel.address    =   userModel.address;
    [PierService serverSend:ePIER_API_GET_UPDATEUSER resuest:requestModel successBlock:^(id responseModel) {
//        PierUpdateResponse *response = (PierUpdateResponse *)responseModel;
        [self serviceCredtiApply];
    } faliedBlock:^(NSError *error) {
        
    } attribute:nil];
}


- (void)serviceCredtiApply{
    PierCreditApplyRequest *requestModel = [[PierCreditApplyRequest alloc] init];
    [PierService serverSend:ePIER_API_GET_APPLYCREDIT resuest:requestModel successBlock:^(id responseModel) {
        PierCreditApplyResponse *response = (PierCreditApplyResponse *)responseModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            PierCreditApproveViewController *registerVC = [[PierCreditApproveViewController alloc] initWithNibName:@"PierCreditApproveViewController" bundle:pierBoundle()];
            registerVC.responseModel = response;
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
