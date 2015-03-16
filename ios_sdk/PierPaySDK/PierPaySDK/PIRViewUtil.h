//
//  PIRViewUtil.h
//  Pier
//
//  Created by zyma on 11/19/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    LS_DEFAULT,     //实线
    LS_DASH         //虚线
} PIRLineStyle;

typedef enum {
    LD_HORIZONTAL,  //横向
    LD_VERTICAL     //纵向
} PIRLineDirection;

#define TEXTFIELD_PLACEHOLDER_TEXTCOLOR @"_placeholderLabel.textColor"

@interface PIRViewUtil : NSObject

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

@end


@interface PIRLineView : UIView

@property (nonatomic, assign) PIRLineStyle style;
@property (nonatomic, assign) PIRLineDirection direction;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *lineColor;

+ (PIRLineView *)getLineWithDirection:(PIRLineDirection)direction
                                color:(UIColor *)color
                                style:(PIRLineStyle)style;

+ (PIRLineView *)getLineWithDirection:(PIRLineDirection)direction
                                color:(UIColor *)color
                                style:(PIRLineStyle)style
                            lineWidth:(CGFloat)width;
@end

@interface UIView (Effects)

- (void)blur;
- (void)unBlur;

@end

@interface PIRBlockSchemeView : UIView
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, strong)UIColor *lineColor;
@property (nonatomic, strong)UIView *schemeView;

+ (PIRBlockSchemeView *)getBlockSchemWithHeight:(CGFloat)height OriginX:(CGFloat)x OriginY:(CGFloat)y LineWidth:(CGFloat)width;
- (void)setSchemeLineColor:(UIColor *)color;
@end

