//
//  PriductListTableViewCell.m
//  PierPayDemo
//
//  Created by zyma on 4/5/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "ProductListTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ShoppingCartModel ()

@end

@implementation ShoppingCartModel

@end

@interface ProductListTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UIButton *buyNowButton;
@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;

@property (nonatomic, strong) ProductModel *cellModel;

@end

@implementation ProductListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCell:(ProductModel *)model{
    self.cellModel = model;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    [self.amountLabel setText:[NSString stringWithFormat:@"$%0.2f",[model.amount floatValue]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buyNowAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyNow:)]) {
        [self.delegate buyNow:self.cellModel];
    }
}

- (IBAction)addToCartAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addToCart:)]) {
        [self.delegate addToCart:self.cellModel];
    }
}

@end

@interface ProductCartTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIButton *plusButton;
@property (nonatomic, weak) IBOutlet UIButton *minusButton;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;

@property (nonatomic, strong) ShoppingCartModel *shopModel;

@end

@implementation ProductCartTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCell:(ShoppingCartModel *)model indexPath:(NSIndexPath *)indexPath{
    self.shopModel = model;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:model.productModel.image]];
    [self.countLabel setText:[NSString stringWithFormat:@"%ld",model.productCount]];
    CGFloat totalAmount = [model.productModel.amount floatValue] * model.productCount;
    [self.amountLabel setText:[NSString stringWithFormat:@"%0.2f",totalAmount]];
}

- (IBAction)plusAction:(id)sender{
    NSInteger currentCount = [[self.countLabel text] integerValue];
    currentCount += 1;
    [self.countLabel setText:[NSString stringWithFormat:@"%ld",currentCount]];
    self.shopModel.productCount = currentCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeCart)]) {
        [self.delegate changeCart];
    }
}

- (IBAction)minusAction:(id)sender{
    NSInteger currentCount = [[self.countLabel text] integerValue];
    currentCount -= 1;
    if (currentCount < 0) {
        currentCount = 0;
    }
    [self.countLabel setText:[NSString stringWithFormat:@"%ld",currentCount]];
    self.shopModel.productCount = currentCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeCart)]) {
        [self.delegate changeCart];
    }
}

@end