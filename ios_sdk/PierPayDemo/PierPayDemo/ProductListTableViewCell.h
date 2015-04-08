//
//  PriductListTableViewCell.h
//  PierPayDemo
//
//  Created by zyma on 4/5/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchantModel.h"

@protocol ProductListTableViewCellDeleagte <NSObject>

@optional
- (void)buyNow:(ProductModel *)model;
- (void)addToCart:(ProductModel *)model;
- (void)changeCart;

@end

@interface ShoppingCartModel : NSObject

@property (nonatomic, strong) ProductModel *productModel;
@property (nonatomic, assign) NSInteger productCount;

@end

@interface ProductListTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ProductListTableViewCellDeleagte> delegate;

- (void)updateCell:(ProductModel *)model;

@end


@interface ProductCartTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ProductListTableViewCellDeleagte> delegate;

- (void)updateCell:(ShoppingCartModel *)model indexPath:(NSIndexPath *)indexPath;

@end