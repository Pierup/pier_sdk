//
//  ProductViewController.m
//  PierPayDemo
//
//  Created by JHR on 15/3/5.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "ProductViewController.h"
#import "PierPay.h"
#import "PIRHttpExecutor.h"
#import "SDWebImage/UIImageView+WebCache.h"

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

        _productImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 130, 130)];
        [self.contentView addSubview:_productImageView];
        
        _currencyLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 135, 30, 40, 40)];
        _currencyLabel.font = [UIFont systemFontOfSize:25];
        _currencyLabel.textAlignment =  NSTextAlignmentRight;
        _currencyLabel.text = @"$";
        [self.contentView addSubview:_currencyLabel];
        
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 30, 80, 40)];
        _amountLabel.font = [UIFont systemFontOfSize:25];
        _amountLabel.text = @"0.00";
        [self.contentView addSubview:_amountLabel];
        
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 120), 80, 110,40)];
        [_payButton.layer setCornerRadius:5];
        [_payButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_payButton setBackgroundColor:[UIColor colorWithRed:23/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]];
        [_payButton setTitle:@"Pay With Pier" forState:UIControlStateNormal];
        [_payButton.layer setMasksToBounds:YES];
        [self.contentView addSubview:_payButton];
    }
    return self;
}

- (void)setAmountLabel:(NSString *)amountName currencyLabel:(NSString *)currencyName productImageUrl:(NSString *)productImageUrl
{
    _amountLabel.text = amountName;
    _currencyLabel.text = [currencyName isEqualToString:@"USD"] ? @"$" : currencyName;
    [_productImageView sd_setImageWithURL:[NSURL URLWithString:productImageUrl]];
}

@end


#pragma mark ------------------- ProductViewController --------------------

@interface ProductViewController()<UITableViewDataSource, UITableViewDelegate, PierPayDelegate, UIActionSheetDelegate>

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
        _merchantParam = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"Product"];
    [self initData];
}

- (void)initData{
    [self getMerchantProduct:self.merchantModel.merchant_id];
}

#pragma mark ------------------- Service ----------------------------------
//Get Products 
- (void)getMerchantProduct:(NSString *)merchant_id
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"2",@"platform",
                         merchant_id,@"merchant_id",
                         nil];
    [[PIRHttpExecutor getInstance] sendMessage:^(id respond) {
        NSArray *array =  [(NSDictionary *)respond objectForKey:@"result"];
        self.productsArray = [NSMutableArray arrayWithCapacity:array.count];
        NSString *server_url = [(NSDictionary *)respond objectForKey:@"server_url"];
        for (int i = 0; i < array.count; i++) {
            ProductModel *shopListModel = [[ProductModel alloc] init];
            shopListModel.amount = [array[i] objectForKey:@"amount"];
            shopListModel.image = [array[i] objectForKey:@"image"];
            shopListModel.currency = [array[i] objectForKey:@"currency"];
            shopListModel.server_url = server_url;
            shopListModel.shop_name = self.merchantModel.business_name;
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
        ProductModel *shopListModel = self.merchantModel.shopListModelArray[sender.tag];
//        [_merchantParam setValue:self.merchantModel.phone forKey:@"phone"];
//        [_merchantParam setValue:self.merchantModel.country_code forKey:@"country_code"];
        [_merchantParam setValue:self.merchantModel.merchant_id forKey:@"merchant_id"];
        [_merchantParam setValue:shopListModel.amount forKey:@"amount"];
        [_merchantParam setValue:shopListModel.currency forKey:@"currency"];
        [_merchantParam setValue:shopListModel.server_url forKey:@"server_url"];
        [_merchantParam setValue:[self getRandomNumber:1000000000 to:10000000000] forKey:@"order_id"];
        [_merchantParam setValue:shopListModel.shop_name forKey:@"shop_name"];
        [self showSheet];

    }
}

-(NSString *)getRandomNumber:(NSInteger)from to:(NSInteger)to
{
    NSInteger randomInt = (NSInteger)(from+(arc4random() % (to-from+1)));//+1,result is [from to]; else is [from, to)
    return [NSString stringWithFormat:@"%ld",randomInt];
}

- (void)showSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Pier Payment"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Select Payment Model"
                                  otherButtonTitles:@"Pay now", @"Pay With Pier App",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1) {
        PierPay *pierpay = [[PierPay alloc] initWith:_merchantParam delegate:self];
        [self presentViewController:pierpay animated:YES completion:nil];
    }else if(buttonIndex == 2) {
        /**
         * charge
         * name:            Required     Type       Description
         * 1.phone           YES          NSString   user phone.
         * 2.country_code    YES          NSString   the country code of user phone.
         * 3.merchant_id     YES          NSString   your id in pier.
         * 4.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
         * 5.scheme          YES          NSString   merchant App scheme
         */
        NSDictionary *chargeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [_merchantParam objectForKey:@"amount"], @"amount",
                                   [_merchantParam objectForKey:@"currency"], @"currency",
                                   [_merchantParam objectForKey:@"merchant_id"], @"merchant_id",
                                   [_merchantParam objectForKey:@"server_url"], @"server_url",
                                   @"piermerchant", @"scheme",
                                   [_merchantParam objectForKey:@"shop_name"],@"shop_name",nil];
        
        [PierPay createPayment:chargeDic];
        
    }else if(buttonIndex == 3) {
        
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
    

#pragma mark ----------------------- Delegate ------------------------------

#pragma mark - PierPayDelegate

/**
 *
 *  @abstract Call Back When Pay With Pier In Merchant App.
 *
 *  @param result
 *    key        Type            Description
 *  - status     NSNumber        Showing the status of sdk execution.It means successful if is '1', else is '2'.
 *  - message    NSString        Showing the message from pier.
 *  - amount     NSString        amount.
 *  - currency   NSString        NSString
 *  - result     NSDictionary    Showing the value of output params of pier (This parameter is extended).
 *
 */
- (void)payWithPierComplete:(NSDictionary *)result
{
    NSInteger status = [[result objectForKey:@"status"] integerValue];
    if (status == 2) {
        //failed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Failed" message:[NSString stringWithFormat:@"%@",[result objectForKey:@"message"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if (status == 1){
        //success
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Succeeded" message:[NSString stringWithFormat:@"Total Amount: %@",[result objectForKey:@"amount"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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
    [cell.payButton addTarget:self action:@selector(payByPier:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.merchantModel.shopListModelArray) {
        ProductModel *shopListModel = self.merchantModel.shopListModelArray[indexPath.row];
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
