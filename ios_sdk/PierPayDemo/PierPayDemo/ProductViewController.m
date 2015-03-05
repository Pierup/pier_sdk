//
//  ProductViewController.m
//  PierPayDemo
//
//  Created by JHR on 15/3/5.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "ProductViewController.h"
#import "PierPay.h"
#import "DemoHttpExecutor.h"

@interface ProductViewController ()<UITableViewDataSource,UITableViewDelegate,PayByPierDelegate>
@property (nonatomic, weak) IBOutlet UITableView *productTableView;
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) NSMutableDictionary *merchantParam;
@end

@implementation ProductViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _merchantParam = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"Shop List"];
    [self getMerchantProduct:self.merchantModel.merchant_id];
}

//Get Products
- (void)getMerchantProduct:(NSString *)merchant_id{
    DemoHttpExecutor *httpConnect = [DemoHttpExecutor getInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"2",@"platform",
                         merchant_id,@"merchant_id",
                         nil];
    [httpConnect sendMessage:^(id respond) {
        NSDictionary *dic = (NSDictionary *)respond;
        NSArray *array =  [dic objectForKey:@"result"];
        self.listArray = [NSMutableArray arrayWithCapacity:array.count];
        for (int i = 0; i < array.count; i++) {
            ShopListmodel *shopList = [[ShopListmodel alloc] init];
            shopList.amount = [array[i] objectForKey:@"amount"];
            shopList.image = [array[i] objectForKey:@"image"];
            shopList.currency = [array[i]objectForKey:@"currency"];
            [self.listArray addObject:shopList];
        }
        self.merchantModel.shopListModelArray = self.listArray;
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
        
    } andRequestJson:dic andFailure:^(id error, int errorCode) {
        
    } andPath:@"/merchant_api/v1/fake/products" method:@"get"];
    
}
- (void)refreshTable
{
   [self.productTableView reloadData];
}

- (void)payByPier:(UIButton *)sender
{
    if (self.merchantModel.shopListModelArray.count > 0) {
        ShopListmodel *shopListModel = self.merchantModel.shopListModelArray[sender.tag];
        [_merchantParam setValue:self.merchantModel.phone forKey:@"phone"];
        [_merchantParam setValue:self.merchantModel.country_code forKey:@"country_code"];
        [_merchantParam setValue:self.merchantModel.merchant_id forKey:@"merchant_id"];
        [_merchantParam setValue:shopListModel.amount forKey:@"amount"];
        [_merchantParam setValue:shopListModel.currency forKey:@"currency"];
        [_merchantParam setValue:@"http://192.168.1.254:8080/pier-merchant/merchant/server/sdk/pay/" forKey:@"server_url"];
        PierPay *pierpay = [[PierPay alloc] initWith:_merchantParam delegate:self];
        [self presentViewController:pierpay animated:YES completion:nil];
    }

}
/**
 * Result
 * name:        Type            Description
 * 1.status     NSNumber        Showing the status of sdk execution.It means successful if is true,else means fail.
 * 2.message    NSString        Showing the message from pier.
 * 3.code       NSNumber        Showing the code of message from pier.
 * 4.result     NSDictionary    Showing the value of output params of pier.
 */
- (void)payByPierComplete:(NSDictionary *)result{
 
}

#pragma mark ---------------------UITableViewDelegate------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark ---------------------UITableViewDatasource----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.merchantModel.shopListModelArray.count) {
        return 0;
    }
        return self.merchantModel.shopListModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.showsReorderControl = YES;
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 125, 125)];
    UILabel *currencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 22.5, 50, 100)];
    currencyLabel.text = @"$";
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 22.5, 70, 100)];
    amountLabel.text = @"0.00";
    UIButton *payButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 22.5, 100, 100)];
    payButton.tag = indexPath.row;
    [payButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [payButton setTitle:@"Pay by Pier" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payByPier:) forControlEvents:UIControlEventTouchDown];
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:amountLabel];
    [cell.contentView addSubview:currencyLabel];
    [cell.contentView addSubview:payButton];
    if (self.merchantModel.shopListModelArray.count > 0) {
        ShopListmodel  *shopListModel = self.merchantModel.shopListModelArray[indexPath.row];
        amountLabel.text = shopListModel.amount;
        if([shopListModel.currency isEqualToString:@"USD"]){
            currencyLabel.text = @"$";
        }else{
            currencyLabel.text = shopListModel.currency;
        }
        NSURL *photourl = [NSURL URLWithString:shopListModel.image];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *images = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = images;
            });
        });
    }
    return cell;
}
@end
