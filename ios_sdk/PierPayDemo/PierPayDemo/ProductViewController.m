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

        _productImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 110)];
        [self.contentView addSubview:_productImageView];
        
        _currencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 22.5, 40, 100)];
        _currencyLabel.textAlignment =  NSTextAlignmentCenter;
        _currencyLabel.text = @"$";
        [self.contentView addSubview:_currencyLabel];
        
        _amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 22.5, 55, 100)];
        _amountLabel.text = @"0.00";
        [self.contentView addSubview:_amountLabel];
        
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 125), 57.5, 110,30)];
        [_payButton.layer setMasksToBounds:YES];
        [_payButton.layer setCornerRadius:5];
        [_payButton setBackgroundColor:[UIColor purpleColor]];
        [_payButton setTitle:@"Pay With Pier" forState:UIControlStateNormal];
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
        [self showSheet];

    }
}

- (void)showSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Pay with Pier"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Please choose the payment method"
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
         * userAttributes
         * name:            Required     Type       Description
         * 1.phone           YES          NSString   user phone.
         * 2.country_code    YES          NSString   the country code of user phone.
         * 3.merchant_id     YES          NSString   your id in pier.
         * 4.server_url      YES          NSString   your server url of accepting auth token,amount,currency, and making the real payment with the pier server SDK.
         * 5.scheme          YES          NSString   merchant App scheme
         */
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://pier.com?amount=%@&currency=%@&merchant_id=%@&server_url=%@&scheme=%@", @"paywithpier",
                                           [_merchantParam objectForKey:@"amount"],
                                           [_merchantParam objectForKey:@"currency"],
                                           [_merchantParam objectForKey:@"merchant_id"],
                                           [_merchantParam objectForKey:@"server_url"],
                                           @"piermerchant"]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://beta.itunes.apple.com/v1/invite/8f2643ef1c9747ac80332f76120c9f496977c937aa2a44648e6022a5fbf1c2e739c7fa37?ct=9KW7KNZ4KU&pt=2003"]];
        }
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
 * Result
 * name:        Type            Description
 * 1.status     NSNumber        Showing the status of sdk execution.It means successful if is '0',else means '1'.
 * 2.message    NSString        Showing the message from pier.
 * 3.code       NSNumber        Showing the code of message from pier.
 * 4.result     NSDictionary    Showing the value of output params of pier.
 * 5.spending   NSString        spending.
 */
- (void)payWithPierComplete:(NSDictionary *)result
{
    NSInteger status = [[result objectForKey:@"status"] integerValue];
    if (status == 1) {
        //failed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pay With Pier Failed." message:[NSString stringWithFormat:@"%@",[result objectForKey:@"message"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if (status == 0){
        //success
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pay With Pier Success." message:[NSString stringWithFormat:@"Total Amount:%@",[result objectForKey:@"spending"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
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
    [cell.payButton addTarget:self action:@selector(payByPier:) forControlEvents:UIControlEventTouchUpInside];
    
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
