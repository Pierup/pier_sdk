//
//  MainViewController.m
//  PierPayDemo
//
//  Created by JHR on 15/3/5.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "ShopListViewController.h"
#import "PierPay.h"
#import "DemoHttpExecutor.h"
#import "ProductViewController.h"

@implementation ShopListmodel
@end

@implementation MerchantModel
@end

@interface ShopListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *merchantTableView;
@property (nonatomic, strong) NSMutableArray *merchantArray;
@end

@implementation ShopListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Merchant"];
    [self getMerchantList];
}

//Get Merchant List
- (void)getMerchantList{
    DemoHttpExecutor *httpConnect = [DemoHttpExecutor getInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1",@"page_no",
                         @"2",@"platform",
                         @"5",@"limit",
                         nil];
    [httpConnect sendMessage:^(id respond) {
        NSDictionary *dic = (NSDictionary *)respond;
       NSArray *array =  [[dic objectForKey:@"result"] objectForKey:@"items"];
        self.merchantArray = [NSMutableArray arrayWithCapacity:array.count];
        for (int i = 0; i < array.count; i++) {
            MerchantModel *merchant = [[MerchantModel alloc] init];
            merchant.phone = [array[i] objectForKey:@"phone"];
            merchant.country_code = [array[i] objectForKey:@"country_code"];
            merchant.merchant_id = [array[i] objectForKey:@"merchant_id"];
            merchant.product_small_url = [array[i] objectForKey:@"product_small_url"];
            merchant.business_name = [array[i] objectForKey:@"business_name"];
            [self.merchantArray addObject:merchant];
        }
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
    } andRequestJson:dic andFailure:^(id error, int errorCode) {
        
    } andPath:@"/merchant_api/v1/query/get_merchants" method:@"get"];
}

- (void)refreshTable
{
    [self.merchantTableView reloadData];
}
#pragma mark ---------------------UITableViewDelegate------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.merchantArray > 0) {
        ProductViewController *productViewController = [[ProductViewController alloc]init];
        productViewController.merchantModel = self.merchantArray[indexPath.row];
        [self.navigationController pushViewController:productViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark ---------------------UITableViewDatasource----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.merchantArray.count) {
        return 0;
    }
    return self.merchantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.showsReorderControl = YES;
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 145)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 115, [UIScreen mainScreen].bounds.size.width, 30)];
    view.alpha = 0.8;
    view.backgroundColor = [UIColor whiteColor];
    UILabel *merchantNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 115, 200, 30)];
    merchantNameLabel.text = @"Merchant Name";
    merchantNameLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:view];
    [cell.contentView addSubview:merchantNameLabel];
    if (self.merchantArray.count > 0) {
        MerchantModel *merchant = self.merchantArray[indexPath.row];
        merchantNameLabel.text = merchant.business_name;
        NSURL *photourl = [NSURL URLWithString:merchant.product_small_url];
        if (imageView.image == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *images = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = images;
                });
            });
        }
    }
    return cell;
}

@end
