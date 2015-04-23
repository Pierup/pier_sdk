//
//  ProductCartViewController.m
//  PierPayDemo
//
//  Created by zyma on 4/5/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "ProductCartViewController.h"
#import "ProductListTableViewCell.h"
#import "PierPay.h"

@interface ProductCartViewController () <ProductListTableViewCellDeleagte, PierPayDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cartArray; //ShoppingCartModel
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic, strong) NSMutableDictionary *merchantParam;

@end

@implementation ProductCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initView];
}

- (void)initData{
    _merchantParam = [[NSMutableDictionary alloc] init];
    _cartArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    for (ProductModel *model in self.cartProductArray) {
        ShoppingCartModel *carModel = [tempDic objectForKey:model.image];
        if (carModel == nil) {
            ShoppingCartModel *carModel = [[ShoppingCartModel alloc] init];
            carModel.productModel = model;
            carModel.productCount = 1;
            [tempDic setValue:carModel forKey:model.image];
            [_cartArray addObject:carModel];
        }else{
            carModel.productCount += 1;
        }
        _totalAmount += [model.amount floatValue];
    }
}

- (void)initView{
    [self setTitle:@"Shopping Cart"];
    [self.tableView reloadData];
    [self setPayButtonTitle];
}

- (void)setPayButtonTitle{
    [_payButton setTitle:[NSString stringWithFormat:@"Pay($%0.2f)",_totalAmount] forState:UIControlStateNormal];
    if (_totalAmount > 0) {
        [_payButton setBackgroundColor:[UIColor redColor]];
        [_payButton setEnabled:YES];
    }else{
        [_payButton setBackgroundColor:[UIColor grayColor]];
        [_payButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ProductListTableViewCellDeleagte

- (void)changeCart{
    [self.tableView reloadData];
    CGFloat currentTotalAmount = 0.0f;
    for (ShoppingCartModel *mode in self.cartArray) {
        CGFloat currentAmount = mode.productCount * [mode.productModel.amount floatValue];
        currentTotalAmount += currentAmount;
    }
    self.totalAmount = currentTotalAmount;
    [self setPayButtonTitle];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cartProductArray.count > 0) {
        return self.cartArray.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ProductCartTableViewCell";
    ProductCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductListTableViewCell" owner:self options:nil] objectAtIndex:1];
        cell.delegate = self;
    }
    [cell updateCell:[self.cartArray objectAtIndex:indexPath.row] indexPath:indexPath];
    return cell;
}


#pragma mark ----------------------------- Button Action --------------------

- (IBAction)buy:(id)sender{
    ProductModel *model = [self.cartProductArray objectAtIndex:0];
    [_merchantParam setValue:self.merchant_id forKey:@"merchant_id"];
    [_merchantParam setValue:[NSString stringWithFormat:@"%f",self.totalAmount] forKey:@"amount"];
    [_merchantParam setValue:model.currency forKey:@"currency"];
    [_merchantParam setValue:model.server_url forKey:@"server_url"];
    [_merchantParam setValue:[self getRandomNumber:1000000000 to:10000000000] forKey:@"order_id"];
    [_merchantParam setValue:model.shop_name forKey:@"shop_name"];
    [self showSheet];
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
        [self.navigationController popViewControllerAnimated:NO];
    }
}


@end
