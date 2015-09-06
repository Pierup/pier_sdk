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
    
    NSString *sign = [RSADigitalSignature createSignature:@"123" privateKey:@"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAPbRrFFeG9ViAwYk"
                      "BdeWel4BIVP3JjpQDjTBN3c63SWEa64J+iXGX/8/d3x6D9aVIiLzbwQ5afJ4DA4V"
                      "wLjiIl09a9xs/X8F0BEWUxKoVXrARGVs1mB5HllnTzEXTOVEn+HjoQURNAuWqBGV"
                      "INjmsLpJl8aMq5fbpSBzxzQC4x3vAgMBAAECgYBzQf6CELxWrOpUl8XSowaJl2WE"
                      "3EkRugioQgIwv2A+ANR39VjHAxgZDf4yNp3mysWiJKOXCWicPcsDWM0iiRcaIKwt"
                      "T4t3fvZ8DR6SFKht5JkjxJYMCwlFVeS2OQ+KOVcXlhWXjUO1V+3N/eXqiGGVeBl9"
                      "mPADcqP4wgzT2SDzYQJBAPtkGNp4peMsv27siVh6JRwxbgAf55Homlisygw7h9Yi"
                      "lJ/5XJABt7Lag2sk1rixY/oH3vhH7g0b4mSdJhEPqaUCQQD7WB4VRdoEtVyqW0Rk"
                      "NnUVnGHhAOGfdh6f/+NMMvbnXkblqCV8c5XxOjdfQMO5hfair0aNJgcA1LLzUAPs"
                      "f80DAkEApE0ylS8/NG/dmhDMX2BNetSvkTNI9SryHbyovT/3MrQdMUUYAyKsPh/k"
                      "vpUwJTwDHLoiN2FDq5uq5ply9Lmo5QJAd5xTlKQNQLheROPyBA62YXZuTflxZcV8"
                      "hX/s11JZlXmUG66NSFBpRscBmt7jReKuoHTxCjLSml6eWpP1ihK3qQJBALvInreQ"
                      "dfTIAZS2oYYoE340ohHLbow4+uEOXnSkD2m95MqNg4ghda6fwAS7O+lIt5vEB4nV"
                      "X/nCZkNpHjMXDPo="];
    
    BOOL check = [RSADigitalSignature verify:@"123" sign:sign publicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD20axRXhvVYgMGJAXXlnpeASFT"
                  "9yY6UA40wTd3Ot0lhGuuCfolxl//P3d8eg/WlSIi828EOWnyeAwOFcC44iJdPWvc"
                  "bP1/BdARFlMSqFV6wERlbNZgeR5ZZ08xF0zlRJ/h46EFETQLlqgRlSDY5rC6SZfG"
                  "jKuX26Ugc8c0AuMd7wIDAQAB"];
    
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
