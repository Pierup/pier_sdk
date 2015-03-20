//
//  MerchantCollectionViewCell.h
//  PierPayDemo
//
//  Created by JHR on 15/3/20.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *merchantNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *merchantImageView;

- (void)setMerchantNameLabel:(NSString *)merchantName merchantImageViewUrl:(NSString *)merchantImageViewUrl;

@end
