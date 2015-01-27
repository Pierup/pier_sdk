//
//  ViewController.m
//  PierPayDemo
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import "ViewController.h"
#import "PierPay.h"
@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)payByPier:(id)sender{
//    [PierPaySDK test:self.textView.text];
    PierPay *pierpay = [[PierPay alloc] init];
    [self presentViewController:pierpay animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
