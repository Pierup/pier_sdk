//
//  MerchantCollectionViewCell.m
//  PierPayDemo
//
//  Created by JHR on 15/3/20.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import "MerchantCollectionViewCell.h"

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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:merchantImageViewUrl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _merchantImageView.image = image;
        });
    });
}

@end
