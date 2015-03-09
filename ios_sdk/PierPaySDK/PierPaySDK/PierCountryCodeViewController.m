//
//  PierCountryCodeViewController.m
//  PierPaySDK
//
//  Created by JHR on 15/3/7.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "PierCountryCodeViewController.h"
#import "PIRPayModel.h"
#import "PIRService.h"

@interface PierCountryCodeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *countryCodeTableView;
@property (nonatomic, strong) NSDictionary *countryCodeDictionary;

@end

@implementation PierCountryCodeViewController


#pragma mark - --------------------System--------------------
#pragma mark - --------------------功能函数--------------------
#pragma mark 初始化

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.countryCodeDictionary = @{@"US" : @"+1",@"CHINA" : @"+86"};
        self.countryType = eCountryType_US;   //初始为美国
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Country Code"];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissCountryCodeViewController)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    //test
    [self serviceCountryService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(countryCode:countryName:countryCodeViewController:)]) {
        NSString *countryName = self.countryCodeDictionary.allKeys[indexPath.row];
        NSString *countryCode = [self.countryCodeDictionary objectForKey:self.countryCodeDictionary.allKeys[indexPath.row]];
        [self.delegate countryCode:countryCode countryName:countryName countryCodeViewController:self];
        [self dismissCountryCodeViewController];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.countryCodeDictionary.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.text = self.countryCodeDictionary.allKeys[indexPath.row];
        cell.detailTextLabel.text = [self.countryCodeDictionary objectForKey:self.countryCodeDictionary.allKeys[indexPath.row]];
    }
    return cell;
}

#pragma mark - --------------------属性相关--------------------
#pragma mark 属性操作函数注释

#pragma mark - --------------------接口API--------------------
#pragma mark 分块内接口函数注释
- (void)serviceCountryService{
    CountryCodeRequest *requestModel = [[CountryCodeRequest alloc] init];
    [PIRService serverSend:ePIER_API_GET_COUNTRYS resuest:requestModel successBlock:^(id responseModel) {
        CountryCodeResponse *response = (CountryCodeResponse *)responseModel;
        
    } faliedBlock:^(NSError *error) {

    } attribute:nil];
}

@end
