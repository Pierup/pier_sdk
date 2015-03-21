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
    self.merchantNameLabel.layer.cornerRadius = 5;
    self.merchantNameLabel.layer.masksToBounds = YES;
}

- (void)setMerchantNameLabel:(NSString *)merchantName merchantImageViewUrl:(NSString *)merchantImageViewUrl indexPath:(NSIndexPath *)indexPath
{
    _merchantNameLabel.text = merchantName;
    _indexPath =  indexPath;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:merchantImageViewUrl];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
            });
        }  
    });
    [self.imageButton addTarget:self action:@selector(tapImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapImageButtonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(merchantCollectionViewWithIndexPath:)]) {
        [self.delegate merchantCollectionViewWithIndexPath:self.indexPath];
    }
}

@end
