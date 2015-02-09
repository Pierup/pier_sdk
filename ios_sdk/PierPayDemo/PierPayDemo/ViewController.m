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
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)payByPier:(id)sender{
//    [PierPaySDK test:self.textView.text];
    NSDictionary *userAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Peter",       @"name",
                                    @"1234567890",  @"phone",
                                    @"US",          @"country_code",nil];
    PierPay *pierpay = [[PierPay alloc] initWith:userAttributes];
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
