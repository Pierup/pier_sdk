//
//  PierCountryCodeViewController.m
//  PierPaySDK
//
//  Created by JHR on 15/3/7.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "PierCountryCodeViewController.h"
#import "PierService.h"
#import "PierDataSource.h"
#import "PierFont.h"

@implementation PierCountryModel

@end


@interface PierCountryCodeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *countryCodeTableView;
@property (nonatomic, strong) NSMutableArray *countryArray;

@end

@implementation PierCountryCodeViewController


#pragma mark - --------------------System--------------------
#pragma mark - --------------------功能函数--------------------
#pragma mark 初始化

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.countryArray = [NSMutableArray array];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Country Code"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissCountryCodeViewController)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    if (self.countryArray.count == 0) {
        [self serviceCountryService];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - --------------------手势事件--------------------
#pragma mark 各种手势处理函数注释

#pragma mark - --------------------按钮事件--------------------

#pragma mark - leftBarButtonItemAction
- (void)dismissCountryCodeViewController
{
   [self dismissViewControllerAnimated:YES completion:^{
    
   }];
}

#pragma mark - --------------------代理方法--------------------

#pragma mark - UITableViewDelgate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(countryCodeWithCountry:)]) {
       PierCountry *country =  self.countryArray[indexPath.row];
        [__pierDataSource.merchantParam setValue:country.country_code forKey:DATASOURCES_COUNTRY_CODE];
        [self.delegate countryCodeWithCountry:country];
        [self dismissCountryCodeViewController];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.countryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        PierCountry *countryModel = self.countryArray[indexPath.row];
        cell.textLabel.text = countryModel.name;
        [cell.textLabel setFont:[PierFont customFontWithSize:15]];
        cell.detailTextLabel.text =[NSString stringWithFormat:@"+%@",countryModel.phone_prefix];
        
        if ([countryModel.country_code isEqualToString:self.selectedCountryModel.country_code]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

#pragma mark - --------------------属性相关--------------------
#pragma mark 属性操作函数注释

#pragma mark - --------------------接口API--------------------
#pragma mark 分块内接口函数注释
- (void)serviceCountryService
{
    PierCountryCodeRequest *requestModel = [[PierCountryCodeRequest alloc] init];
    [PierService serverSend:ePIER_API_GET_COUNTRYS resuest:requestModel successBlock:^(id responseModel) {
        PierCountryCodeResponse *response = (PierCountryCodeResponse *)responseModel;
        // 转换成模型数组模型对象
        for (PierCountry *country in response.items) {
            PierCountryModel *countryModel = [[PierCountryModel alloc]init];
            countryModel.name = country.name;
            countryModel.phone_prefix = country.phone_prefix;
            countryModel.phone_size = country.phone_size;
            countryModel.country_code = country.code;
            [self.countryArray addObject:countryModel];
        }
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
    } faliedBlock:^(NSError *error) {

    } attribute:nil];
}

#pragma mamrk ---------------- 功能函数 ----------------------
- (void)refreshTable
{
    [self.countryCodeTableView reloadData];
}

@end

