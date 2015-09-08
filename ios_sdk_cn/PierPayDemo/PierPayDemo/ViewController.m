//
//  ViewController.m
//  PierPayDemo
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import "ViewController.h"
#import "PushViewController.h"
#import "RSADigitalSignature.h"
#import "PierPaySDK.h"
#import "RSADigitalSignature.h"
#import "OrderUtil.h"

@interface ProductCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *productLabel;
@property (nonatomic, weak) IBOutlet UILabel *productDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel *salesLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic, weak) IBOutlet UIButton *shopCarButton;

@property (nonatomic, weak) IBOutlet UIImageView *productLogoImage;

@end

@implementation ProductCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.payButton.layer setBorderColor:[[UIColor redColor] CGColor]];
    [self.payButton.layer setBorderWidth:0.5f];
    [self.shopCarButton.layer setBorderColor:[[UIColor orangeColor] CGColor]];
    [self.shopCarButton.layer setBorderWidth:0.5f];
}

@end

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) PierPaySDK *pierPay;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
    [self getProductList];
    
    [self.tableView reloadData];
    
    [self setTitle:@"首页"];
}

- (void)getProductList{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"products" ofType:@"plist"];
    _data = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (IBAction)payByPier:(id)sender{
    NSDictionary *param = @{
                            @"merchant_id":@"MC0000001409",
                            @"api_id":@"1819957c-1a3f-11e5-ba25-3a22fd90d682",
                            @"api_secret_key":@"mk-prod-18199475-1a3f-11e5-ba25-3a22fd90d682",
                            @"amount":@"11.01",
                            @"charset":@"UTF-8",
                            @"order_id":@"fsdirwl24932130fs",
                            @"return_url":@"/checkout/orderList",
                            @"order_detail":@"",
                            @"sign_type":@"RSA"
                            };
    
    NSString *sign = [OrderUtil getSgin:param];
    
    NSDictionary *charge = @{
                             @"merchant_id":@"MC0000001409",
                             @"api_id":@"1819957c-1a3f-11e5-ba25-3a22fd90d682",
                             @"api_secret_key":@"mk-prod-18199475-1a3f-11e5-ba25-3a22fd90d682",
                             @"amount":@"11.01",
                             @"charset":@"UTF-8",
                             @"order_id":@"fsdirwl24932130fs",
                             @"return_url":@"/checkout/orderList",
                             @"order_detail":@"",
                             @"sign_type":@"RSA",
                             @"sign":sign
                             };
    
    _pierPay = [[PierPaySDK alloc] init];
    
    [_pierPay createPayment:charge delegate:self fromScheme:@"" completion:^(NSDictionary *result, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    static NSString *indetifier = @"ProductCell";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    [cell.productLabel setText:[_data[row] objectForKey:@"product"]];
    [cell.productDetailLabel setText:[_data[row] objectForKey:@"detail"]];
    [cell.salesLabel setText:[_data[row] objectForKey:@"sales"]];
    [cell.priceLabel setText:[_data[row] objectForKey:@"price"]];
    [cell.productLogoImage setImage:[UIImage imageNamed:[_data[row] objectForKey:@"logo"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    switch (indexPath.row) {
//        case 0:
//            [self performSegueWithIdentifier:@"push" sender:self];
//            break;
//        case 1:
//            [self performSegueWithIdentifier:@"modal" sender:self];
//            break;
//        default:
//            break;
//    }
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.

 }



@end
