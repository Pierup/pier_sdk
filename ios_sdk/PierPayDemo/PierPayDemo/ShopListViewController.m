//
//  MainViewController.m
//  PierPayDemo
//
//  Created by JHR on 15/3/5.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "ShopListViewController.h"
#import "PIRHttpExecutor.h"
#import "ProductViewController.h"

#pragma mark -------------------- ShopListModel -----------------------------

@implementation ShopListModel

@end


#pragma mark -------------------- MerchantModel -----------------------------

@implementation MerchantModel

@end


#pragma mark -------------------- ShopListCell ------------------------------

@interface ShopListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *merchantImageView;
@property (nonatomic, strong) UIView *backdropView;
@property (nonatomic, strong) UILabel *merchantNameLabel;

- (void)setMerchantNameLabel:(NSString *)merchantName merchantImageViewUrl:(NSString *)merchantImageViewUrl;

@end


@implementation ShopListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _merchantImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 145)];
        _merchantImageView.image = [UIImage imageNamed:@"shop_default"];
        [self.contentView addSubview:_merchantImageView];
        
        _backdropView = [[UIView alloc]initWithFrame:CGRectMake(0, 115, [UIScreen mainScreen].bounds.size.width, 30)];
        _backdropView.backgroundColor = [UIColor whiteColor];
        _backdropView.alpha = 0.8;
        [self.contentView addSubview:_backdropView];
        
        _merchantNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 115, 200, 30)];
        _merchantNameLabel.text = @"Merchant Name";
        [self.contentView addSubview:_merchantNameLabel];
    }
    return self;
}

- (void)setMerchantNameLabel:(NSString *)merchantName merchantImageViewUrl:(NSString *)merchantImageViewUrl
{
    _merchantNameLabel.text = merchantName;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:merchantImageViewUrl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _merchantImageView.image = image;
        });
    });
}

@end


#pragma mark -------------------- ShopListViewController ------------------

@interface ShopListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *merchantTableView;
@property (nonatomic, strong) NSMutableArray *merchantArray;

@end


@implementation ShopListViewController

#pragma mark -------------------------- System ----------------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"Merchant"];
    [self getMerchantList];
}

#pragma mark ------------------- Service ----------------------------------
// Get Merchant List
- (void)getMerchantList
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1",@"page_no",
                         @"2",@"platform",
                         @"5",@"limit",
                         nil];
    [[PIRHttpExecutor getInstance] sendMessage:^(id respond) {
       NSArray *array =  [[(NSDictionary *)respond objectForKey:@"result"] objectForKey:@"items"];
        self.merchantArray = [NSMutableArray arrayWithCapacity:array.count];
        for (int i = 0; i < array.count; i++) {
            MerchantModel *merchant = [[MerchantModel alloc] init];
            merchant.phone = [array[i] objectForKey:@"phone"];
            merchant.country_code = [array[i] objectForKey:@"country_code"];
            merchant.merchant_id = [array[i] objectForKey:@"merchant_id"];
            merchant.product_small_url = [array[i] objectForKey:@"product_small_url"];
            merchant.business_name = [array[i] objectForKey:@"business_name"];
            [self.merchantArray addObject:merchant];
        }
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
    } andRequestJson:dic andFailure:^(id error, int errorCode) {
        
    } andPath:@"/merchant_api/v1/query/get_merchants" method:@"get"];
}

#pragma mark ----------------------- Delegate ------------------------------

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.merchantArray) {
        ProductViewController *productViewController = [[ProductViewController alloc]init];
        productViewController.merchantModel = self.merchantArray[indexPath.row];
        [self.navigationController pushViewController:productViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.merchantArray.count > 0) {
        return self.merchantArray.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ShopListCell";
    ShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ShopListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.merchantArray) {
        MerchantModel *merchant = self.merchantArray[indexPath.row];
        [cell setMerchantNameLabel:merchant.business_name merchantImageViewUrl:merchant.product_small_url];
    }
    return cell;
}

#pragma mark ----------------------- Functions -----------------------------

- (void)refreshTable
{
    [self.merchantTableView reloadData];
}

@end
