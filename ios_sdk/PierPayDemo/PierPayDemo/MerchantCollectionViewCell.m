//
//  MerchantCollectionViewCell.m
//  PierPayDemo
//
//  Created by JHR on 15/3/20.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "MerchantCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation MerchantCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.merchantImageView.layer.cornerRadius =  5;
    self.merchantImageView.layer.masksToBounds = YES;
    
    self.merchantNameLabel.layer.cornerRadius = 5;
    self.merchantNameLabel.layer.masksToBounds = YES;
}

- (void)setMerchantNameLabel:(NSString *)merchantName merchantImageViewUrl:(NSString *)merchantImageViewUrl
{
    _merchantNameLabel.text = merchantName;
    [_merchantImageView sd_setImageWithURL:[NSURL URLWithString:merchantImageViewUrl]];
}

@end
