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

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _data = @[@{@"title":@"PayByPier", @"detail":@"push"}, @{@"title":@"PayByPier", @"detail":@"model"}];
    
    NSString *sign = [RSADigitalSignature generateSignature:_data.description privateKey:@"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKO+83rgpW71dspo"
     "uBw9iCQHJLWAAGAU4f/29nw6kZ8j3O8/GMWvAsgX2HguZOVPt4rCAMLFI+UtxiiF"
     "OmNNGf+g3xBaSwBlb8dk9Ien19v/SL2ck3u6xZRoQDe6FsLGFFxyL1rbzUgESLN3"
     "N3lYbl8L4V0A/wIy1zUFYC8O4yxjAgMBAAECgYACFM5BdJOFuob9AaG9cibF1nVn"
     "/S2ECx/oQfpWD+SD8k+/lry43oWZh3wP4v8TTxUVJWwfDaRsKE3JfBAG7Rb0fKCD"
     "Du56HWp12fgist6Rblt7/a/VkBm2fdLtwghruzGHPTlvN5Uce9nqCggakvgPKJFs"
     "7J7PSxZjZ7soxKOPqQJBANUCYG9jGeYQaBIhcSdTkrjEzjgnTou6+QEHbY0Ft8yT"
     "vBcC+WsiaQ/5I7MYlWVNew8ffKiHBDahN9pg1h3nSs0CQQDEy0Q34R//9szn4VOo"
     "YwDFKI2caLgdIcgbfcIyix9gYDl6nuBb+dUhrBl2oZ+zoBVGBy4Vjdat8P9IU7Uz"
     "Q7PvAkB0TxTrHVjB58l7xOjtSVP/Me9MeCIKaDCY4D5wV2Px/+UfR497cVGe2DIn"
     "E9BXfUQpkM7Xksm5LrS5uFCSCX4tAkANRn0Km/gxpy95cPzYvhz+L9cltva8mFvM"
     "ZvZjvHjYYoVeHTubWMYk6FwrYYnJb0IgIDneoFvcDgbalTMDC00nAkEAvB4bXJDY"
     "ATNmYtxO71rMA+10A5PWxzK54ENr/QibT6uoI5XRiWkIpJa+EDu2RwnWgO5dP9Ef"
     "Tg1dsfVvzc3fSg=="];
    
    [self setTitle:@"首页"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell.textLabel.text = [_data[indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text =[_data[indexPath.row] objectForKey:@"detail"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"push" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"modal" sender:self];
            break;
        default:
            break;
    }
}

 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.

 }



@end
