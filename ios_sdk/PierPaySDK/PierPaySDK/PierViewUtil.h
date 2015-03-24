//
//  PierViewUtil.h
//  Pier
//
//  Created by zyma on 11/19/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PierTransactionSMSResponse;

typedef enum {
    LS_DEFAULT,     //实线
    LS_DASH         //虚线
} PierLineStyle;

typedef enum {
    LD_HORIZONTAL,  //横向
    LD_VERTICAL     //纵向
} PierLineDirection;

#define TEXTFIELD_PLACEHOLDER_TEXTCOLOR @"_placeholderLabel.textColor"

@interface PierViewUtil : NSObject

+ (void)toToLoginViewController;
+ (void)toCreditApplyViewController:(PierTransactionSMSResponse *)model;
+ (UIViewController *)getCurrentViewController;

+ (void)horizonView:(UIView *)view;

+ (void)drawSeparotorLineTab:(UIView *)view;
+ (void)drawSeparotorLineTab:(UIView *)view withColor:(UIColor *)color;
+ (void)drawSeparotorLine:(UIView *)view;
+ (void)drawScreenSeparotorLine:(UIView *)view;
+ (void)drawSeparotorLine15:(UIView *)view;//两边留15
+ (void)drawSeparotorLineTop:(UIView *)view;
+ (void)drawSeparotorLineVerticalCenter:(UIView *)view;

//添加矩形边框
+ (void)drawRectLine:(UIView *)view;
/** 动画 */
+ (void)shakeView:(UIView *)view;
/** 获取条纹纹理图片 */
+ (UIView *)getStriaView;

+ (UIImage *)getImageByView:(UIView *)view;

/** 按钮正常背景  */
+ (UIImage *)getDarkPurpleColorImage:(CGRect)frame;

/** 按钮按下背景 */
+ (UIImage *)getLightPurpleColorImage:(CGRect)frame;

@end


@interface PierLineView : UIView

@property (nonatomic, assign) PierLineStyle style;
@property (nonatomic, assign) PierLineDirection direction;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *lineColor;

+ (PierLineView *)getLineWithDirection:(PierLineDirection)direction
                                color:(UIColor *)color
                                style:(PierLineStyle)style;

+ (PierLineView *)getLineWithDirection:(PierLineDirection)direction
                                color:(UIColor *)color
                                style:(PierLineStyle)style
                            lineWidth:(CGFloat)width;
@end

