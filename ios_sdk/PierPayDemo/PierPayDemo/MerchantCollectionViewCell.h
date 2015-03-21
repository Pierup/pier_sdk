//
//  MerchantCollectionViewCell.h
//  PierPayDemo
//
//  Created by JHR on 15/3/20.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MerchantCollectionViewCellDelegate<NSObject>

- (void)merchantCollectionViewWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MerchantCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *merchantNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *imageButton;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<MerchantCollectionViewCellDelegate>delegate;

- (void)setMerchantNameLabel:(NSString *)merchantName merchantImageViewUrl:(NSString *)merchantImageViewUrl indexPath:(NSIndexPath *)indexPath;

@end
