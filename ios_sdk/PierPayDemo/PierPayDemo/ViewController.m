//
//  ViewController.m
//  PierPayDemo
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "ViewController.h"
#import "PierPay.h"
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
                      @"http://192.168.1.96:8080/pier-merchant/merchant/server/sdk/pay/", @"server_url",nil];
    
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
    PierPay *pierpay = [[PierPay alloc] initWith:_merchantParam];
    pierpay.pierDelegate = self;
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
    [_merchantParam setValue:self.countryCodeLabel.text forKey:@"phone"];
    [_merchantParam setValue:self.merchantIDLabel.text forKey:@"phone"];
    [_merchantParam setValue:self.amountLabel.text forKey:@"phone"];
    [_merchantParam setValue:self.currencyLabel.text forKey:@"phone"];
    [_merchantParam setValue:self.serviewURL.text forKey:@"phone"];
}

/**
 * Result
 * name:        Type            Description
 * 1.status     NSNumber        Showing the status of sdk execution.It means successful if is true,else means fail.
 * 2.message    NSString        Showing the message from pier.
 * 3.code       NSNumber        Showing the code of message from pier.
 * 4.result     NSDictionary    Showing the value of output params of pier.
 */
-(void)payByPierComplete:(NSDictionary *)result{
    
}
@end
