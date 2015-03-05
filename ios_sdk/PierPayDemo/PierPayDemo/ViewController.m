//
//  ViewController.m
//  PierPayDemo
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "ViewController.h"
#import "PierPay.h"
#import "DemoHttpExecutor.h"
@interface ViewController () <PayByPierDelegate>

@property (nonatomic, weak) IBOutlet UITextField *phoneLabel;
@property (nonatomic, weak) IBOutlet UITextField *countryCodeLabel;
@property (nonatomic, weak) IBOutlet UITextField *merchantIDLabel;
@property (nonatomic, weak) IBOutlet UITextField *amountLabel;
@property (nonatomic, weak) IBOutlet UITextField *currencyLabel;
@property (nonatomic, weak) IBOutlet UITextField *serviewURL;

@property (nonatomic, strong) NSMutableDictionary *merchantParam;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.phoneLabel becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.phoneLabel resignFirstResponder];
}

- (void)initData{
    _merchantParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      @"1879654567", @"phone",
                      @"US", @"country_code",
                      @"MC0000000134", @"merchant_id",
                      @"500", @"amount",
                      @"USD", @"currency",
                      @"http://192.168.1.254:8080/pier-merchant/merchant/server/sdk/pay/", @"server_url",nil];
    
    [self.phoneLabel setText:[_merchantParam objectForKey:@"phone"]];
    [self.countryCodeLabel setText:[_merchantParam objectForKey:@"country_code"]];
    [self.merchantIDLabel setText:[_merchantParam objectForKey:@"merchant_id"]];
    [self.amountLabel setText:[_merchantParam objectForKey:@"amount"]];
    [self.currencyLabel setText:[_merchantParam objectForKey:@"currency"]];
    [self.serviewURL setText:[_merchantParam objectForKey:@"server_url"]];
}

- (void)initView{
    
}


- (IBAction)payByPier:(id)sender{
    [self setMerchantParam];
    PierPay *pierpay = [[PierPay alloc] initWith:_merchantParam delegate:self];
    [self presentViewController:pierpay animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)setMerchantParam{
    [_merchantParam setValue:self.phoneLabel.text forKey:@"phone"];
    [_merchantParam setValue:self.countryCodeLabel.text forKey:@"country_code"];
    [_merchantParam setValue:self.merchantIDLabel.text forKey:@"merchant_id"];
    [_merchantParam setValue:self.amountLabel.text forKey:@"amount"];
    [_merchantParam setValue:self.currencyLabel.text forKey:@"currency"];
    [_merchantParam setValue:self.serviewURL.text forKey:@"server_url"];
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

- (IBAction)testBtnGetMerchantList{
    [self getMerchantList];
}

- (IBAction)testBtnGetProductList:(id)sender{
    [self getMerchantProduct:@"MC0000000134"];
}

//Get Merchant List
- (void)getMerchantList{
    DemoHttpExecutor *httpConnect = [DemoHttpExecutor getInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"5",@"page_no",
                         @"2",@"platform",
                         @"5",@"limit",
                         nil];
    
    [httpConnect sendMessage:^(NSString *respond) {
        
    } andRequestJson:dic andFailure:^(NSString *error, int errorCode) {
        
    } andPath:@"/merchant_api/v1/query/get_merchants" method:@"get"];
}

//Get Products
- (void)getMerchantProduct:(NSString *)merchant_id{
    DemoHttpExecutor *httpConnect = [DemoHttpExecutor getInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"2",@"platform",
                         merchant_id,@"merchant_id",
                         nil];
    
    [httpConnect sendMessage:^(NSString *respond) {
        
    } andRequestJson:dic andFailure:^(NSString *error, int errorCode) {
        
    } andPath:@"/merchant_api/v1/fake/products" method:@"get"];
}


@end
