//
//  MerchantViewController.m
//  PierPayDemo
//
//  Created by JHR on 15/3/20.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "MerchantViewController.h"
#import "PIRHttpExecutor.h"
#import "MerchantCollectionViewCell.h"
#import "ProductViewController.h"

#pragma mark -------------------- ShopListModel -----------------------------

@implementation ShopListModel

@end


#pragma mark -------------------- MerchantModel -----------------------------

@implementation MerchantModel

@end

#pragma mark ---------------- MerchantViewController ------------------------

@interface MerchantViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic ,weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *merchantArray;

@end

@implementation MerchantViewController

#pragma mark -------------------------- System ----------------------------

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self setTitle:@"Merchant"];
    [self getMerchantList];
     [self.collectionView registerNib:[UINib nibWithNibName:@"MerchantCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MerchantCollectionViewCell"];
}

#pragma mark ------------------- Service ----------------------------------
// Get Merchant List
- (void)getMerchantList
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1",@"page_no",
                         @"2",@"platform",
                         @"10",@"limit",
                         nil];
    [[PIRHttpExecutor getInstance] sendMessage:^(id respond) {
        NSArray *array =  [[(NSDictionary *)respond objectForKey:@"result"] objectForKey:@"items"];
        self.merchantArray = [NSMutableArray arrayWithCapacity:array.count];
        for (int i = 0; i < array.count; i++) {
            MerchantModel *merchant = [[MerchantModel alloc] init];
            merchant.phone = [array[i] objectForKey:@"phone"];
            merchant.country_code = [array[i] objectForKey:@"country_code"];
            merchant.merchant_id = [array[i] objectForKey:@"merchant_id"];
            merchant.product_small_url = [array[i] objectForKey:@"logo_small_url"];
            merchant.business_name = [array[i] objectForKey:@"business_name"];
            [self.merchantArray addObject:merchant];
        }
        [self performSelectorOnMainThread:@selector(refreshCollectionView) withObject:nil waitUntilDone:NO];
    } andRequestJson:dic andFailure:^(id error, int errorCode) {
        
    } andPath:@"/merchant_api/v1/query/get_merchants" method:@"get"];
}

- (void)refreshCollectionView
{
    [self.collectionView reloadData];
}

#pragma mark ----------------------- Delegate ------------------------------


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.merchantArray.count > 0) {
        ProductViewController *productViewController = [[ProductViewController alloc]init];
        productViewController.merchantModel = self.merchantArray[indexPath.row];
        [self.navigationController pushViewController:productViewController animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.merchantArray.count > 0) {
        return self.merchantArray.count;
    }else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MerchantCollectionViewCell";
    MerchantCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.merchantArray.count) {
        MerchantModel *merchant = self.merchantArray[indexPath.row];
        [cell setMerchantNameLabel:merchant.business_name merchantImageViewUrl:merchant.product_small_url];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/3 - 15, [UIScreen mainScreen].bounds.size.width/3+10);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
