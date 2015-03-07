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

#pragma mark ------------------- ProductCell ------------------------------

@interface ProductCell : UITableViewCell

@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *currencyLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIButton *payButton;

- (void)setAmountLabel:(NSString *)amountName currencyLabel:(NSString *)currencyName productImageUrl:(NSString *)productImageUrl;

@end


@implementation ProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _productImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 125, 125)];
        [self.contentView addSubview:_productImageView];
        
        _currencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(135, 22.5, 50, 100)];
        _currencyLabel.textAlignment =  NSTextAlignmentRight;
        _currencyLabel.text = @"$";
        [self.contentView addSubview:_currencyLabel];
        
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 22.5, 60, 100)];
        _amountLabel.text = @"0.00";
        [self.contentView addSubview:_amountLabel];
        
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 57.5, 110,30)];
        [_payButton setBackgroundColor:[UIColor purpleColor]];
        [_payButton setTitle:@"Pay by Pier" forState:UIControlStateNormal];
        [self.contentView addSubview:_payButton];
    }
    return self;
}

- (void)setAmountLabel:(NSString *)amountName currencyLabel:(NSString *)currencyName productImageUrl:(NSString *)productImageUrl
{
        _amountLabel.text = amountName;
        _currencyLabel.text = [currencyName isEqualToString:@"USD"] ? @"$" : currencyName;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:productImageUrl]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _productImageView.image = image;
            });
        });
}

@end


#pragma mark ------------------- ProductViewController --------------------

@interface ProductViewController()<UITableViewDataSource, UITableViewDelegate, PayByPierDelegate>

@property (nonatomic, weak) IBOutlet UITableView *productTableView;
@property (nonatomic, strong) NSMutableArray *productsArray;
@property (nonatomic, strong) NSMutableDictionary *merchantParam;

@end


@implementation ProductViewController

#pragma mark -------------------------- System ----------------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Product"];
        _merchantParam = [[NSMutableDictionary alloc] init];
        [self getMerchantProduct:self.merchantModel.merchant_id];
    }
    return self;
}

#pragma mark ------------------- Service ----------------------------------
//Get Products 
- (void)getMerchantProduct:(NSString *)merchant_id
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"2",@"platform",
                         merchant_id,@"merchant_id",
                         nil];
    [[DemoHttpExecutor getInstance] sendMessage:^(id respond) {
        NSArray *array =  [(NSDictionary *)respond objectForKey:@"result"];
        self.productsArray = [NSMutableArray arrayWithCapacity:array.count];
        NSString *server_url = [(NSDictionary *)respond objectForKey:@"server_url"];
        for (int i = 0; i < array.count; i++) {
            ShopListModel *shopListModel = [[ShopListModel alloc] init];
            shopListModel.amount = [array[i] objectForKey:@"amount"];
            shopListModel.image = [array[i] objectForKey:@"image"];
            shopListModel.currency = [array[i] objectForKey:@"currency"];
            shopListModel.server_url = server_url;
            [self.productsArray addObject:shopListModel];
        }
        self.merchantModel.shopListModelArray = self.productsArray;
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
        
    } andRequestJson:dic andFailure:^(id error, int errorCode) {
        
    } andPath:@"/merchant_api/v1/fake/products" method:@"get"];
    
}

#pragma mark ----------------------------- Button Action --------------------

#pragma mark - payButton Action
- (void)payByPier:(UIButton *)sender
{
    if (self.merchantModel && self.merchantModel.shopListModelArray) {
        ShopListModel *shopListModel = self.merchantModel.shopListModelArray[sender.tag];
        [_merchantParam setValue:self.merchantModel.phone forKey:@"phone"];
        [_merchantParam setValue:self.merchantModel.country_code forKey:@"country_code"];
        [_merchantParam setValue:self.merchantModel.merchant_id forKey:@"merchant_id"];
        [_merchantParam setValue:shopListModel.amount forKey:@"amount"];
        [_merchantParam setValue:shopListModel.currency forKey:@"currency"];
        [_merchantParam setValue:shopListModel.server_url forKey:@"server_url"];
    
        PierPay *pierpay = [[PierPay alloc] initWith:_merchantParam delegate:self];
        [self presentViewController:pierpay animated:YES completion:nil];
    }
}

#pragma mark ----------------------- Delegate ------------------------------

#pragma mark - PayByPierDelegate
/**
 * Result
 * name:        Type            Description
 * 1.status     NSNumber        Showing the status of sdk execution.It means successful if is true,else means fail.
 * 2.message    NSString        Showing the message from pier.
 * 3.code       NSNumber        Showing the code of message from pier.
 * 4.result     NSDictionary    Showing the value of output params of pier.
 */
- (void)payByPierComplete:(NSDictionary *)result
{
 
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.merchantModel.shopListModelArray.count > 0) {
        return self.merchantModel.shopListModelArray.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ProductCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.payButton.tag = indexPath.row;
    }
    [cell.payButton addTarget:self action:@selector(payByPier:) forControlEvents:UIControlEventTouchDown];
    
    if (self.merchantModel.shopListModelArray) {
        ShopListModel *shopListModel = self.merchantModel.shopListModelArray[indexPath.row];
        [cell setAmountLabel:shopListModel.amount currencyLabel:shopListModel.currency productImageUrl:shopListModel.image];
    }
    return cell;
}

#pragma mark ----------------------- Functions -----------------------------

- (void)refreshTable
{
    [self.productTableView reloadData];
}

@end
