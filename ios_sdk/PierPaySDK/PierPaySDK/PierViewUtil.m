//
//  PierViewUtil.m
//  Pier
//
//  Created by zyma on 11/19/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import "PierViewUtil.h"
#import <CoreImage/CoreImage.h>
#import "PierColor.h"
#import "PierTools.h"
#import <math.h>
#import "PierLoginViewController.h"
#import "PierCreditApplyController.h"
#import "PierPayModel.h"
#import "PierDataSource.h"

@implementation PierViewUtil

+ (void)toToLoginViewController{
    PierLoginViewController *loginPage = [[PierLoginViewController alloc] initWithNibName:@"PierLoginViewController" bundle:pierBoundle()];
    id rootViewController = [PierViewUtil getCurrentViewController];
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)rootViewController pushViewController:loginPage animated:YES];
    }else if ([rootViewController isKindOfClass:[UIViewController class]]){
        [[(UIViewController *)rootViewController navigationController] pushViewController:loginPage animated:YES];
    }
}

+ (void)toCreditApplyViewController:(PierTransactionSMSResponse *)model{
    PierCreditApplyController *creditApply = [[PierCreditApplyController alloc] initWithNibName:@"PierCreditApplyController" bundle:pierBoundle()];
    creditApply.model = model;
    id rootViewController = [PierViewUtil getCurrentViewController];
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)rootViewController pushViewController:creditApply animated:YES];
    }else if ([rootViewController isKindOfClass:[UIViewController class]]){
        [[(UIViewController *)rootViewController navigationController] pushViewController:creditApply animated:YES];
    }
}

+ (UIViewController *)getCurrentViewController{
    id rootViewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = ((UINavigationController *)rootViewController).topViewController;
        // 顶层模态视图获取逻辑
        while (((UIViewController *)rootViewController).presentedViewController) {
            rootViewController = ((UIViewController *)rootViewController).presentedViewController;
        }
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            UIViewController *visibleViewController = ((UINavigationController *)rootViewController).visibleViewController;
            if (visibleViewController) {
                rootViewController = visibleViewController;
            }
        }
    }
    return rootViewController;
}

+ (void)horizonView:(UIView *)view{
    CGAffineTransform at_scanRemark =CGAffineTransformMakeRotation(M_PI/2);
    at_scanRemark =CGAffineTransformTranslate(at_scanRemark,0,0);
    [view setTransform:at_scanRemark];
}

+ (void)drawSeparotorLineTab:(UIView *)view{
    PierLineView *line = [PierLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(15, view.bounds.size.height, [[UIScreen mainScreen]bounds].size.width-15, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLineTab:(UIView *)view withColor:(UIColor *)color{
    PierLineView *line = [PierLineView getLineWithDirection:LD_HORIZONTAL color:color style:LS_DEFAULT];
    [line setFrame:CGRectMake(15, view.bounds.size.height, [[UIScreen mainScreen]bounds].size.width-15, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLine:(UIView *)view{
    PierLineView *line = [PierLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(0, view.bounds.size.height, view.bounds.size.width, 1)];
    [view addSubview:line];
}

+ (void)drawScreenSeparotorLine:(UIView *)view{
    PierLineView *line = [PierLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(0, view.bounds.size.height, [[UIScreen mainScreen]bounds].size.width, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLine15:(UIView *)view{
    PierLineView *line = [PierLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(15, view.bounds.size.height, view.bounds.size.width-30, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLineTop:(UIView *)view{
    PierLineView *line = [PierLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLineVerticalCenter:(UIView *)view
{
    PierLineView *line = [PierLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(0, view.bounds.size.height/2, [[UIScreen mainScreen]bounds].size.width, 1)];
    [view addSubview:line];
}

+ (void)drawRectLine:(UIView *)view{
    PierLineView *bottomline = [PierLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [bottomline setFrame:CGRectMake(0, 0, view.bounds.size.width, 1)];
    [view addSubview:bottomline];
    
    PierLineView *topLine = [PierLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [topLine setFrame:CGRectMake(0, view.bounds.size.height - 1, view.bounds.size.width, 1)];
    [view addSubview:topLine];
    
    PierLineView *leftLine = [PierLineView getLineWithDirection:LD_VERTICAL color:[UIColor blackColor] style:LS_DEFAULT];
    [leftLine setFrame:CGRectMake(0, 0, 1, view.bounds.size.height)];
    [view addSubview:leftLine];
    
    PierLineView *rightLine = [PierLineView getLineWithDirection:LD_VERTICAL color:[UIColor blackColor] style:LS_DEFAULT];
    [rightLine setFrame:CGRectMake(view.bounds.size.width - 1, 0, 1, view.bounds.size.height)];
    [view addSubview:rightLine];
}

/** 动画 */
+ (void)shakeView:(UIView *)view{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      nil];
    [keyAn setValues:array];
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    [view.layer addAnimation:keyAn forKey:@"TextAnim"];
}

/** 获取纹理图片 */
+ (UIView *)getStriaView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [view setBackgroundColor:PierColorRGB(121, 60, 162)];
    int lineCount = DEVICE_WIDTH/4;
    for (int i = 0; i < lineCount; i++) {
        PierLineView *line = [PierLineView getLineWithDirection:LD_VERTICAL color:[UIColor blackColor] style:LS_DEFAULT lineWidth:2];
        [line setFrame:CGRectMake(i*4, 0, 1, view.bounds.size.height*2)];
        line.layer.anchorPoint = CGPointMake(1.0,1.0);
        [line setTransform:CGAffineTransformMakeRotation(M_PI/4)];
        [view addSubview:line];
    }
    return view;
}

+ (UIImage *)getImageByView:(UIView *)view{
    CGRect rect = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [view.backgroundColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImg;
}

+ (UIImage *)getDarkPurpleColorImage:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[PierColor darkPurpleColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImg;
}

+ (UIImage *)getLightPurpleColorImage:(CGRect)frame{
    CGRect bacRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(bacRect.size);
    CGContextRef BacContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(BacContext, [[PierColor lightPurpleColor] CGColor]);
    CGContextFillRect(BacContext, bacRect);
    UIImage *BacColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return BacColorImg;
}

@end

@interface PierLineView ()
@property(nonatomic, assign) CGFloat width;
@end

@implementation PierLineView

- (id)init
{
    self = [super init];
    if (self) {
        _style = LS_DEFAULT;
        self.width = 0.5;
        [self initial];
    }
    return self;
}

- (instancetype)init:(CGFloat)width
{
    self = [super init];
    if (self) {
        _style = LS_DEFAULT;
        self.width = width;
        [self initial];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = LS_DEFAULT;
        [self initial];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _style = LS_DEFAULT;
        [self initial];
    }
    return self;
}

+ (PierLineView *)getLineWithDirection:(PierLineDirection)direction
                                color:(UIColor *)color
                                style:(PierLineStyle)style
{
    PierLineView *line = [[PierLineView alloc] init];
    if (line) {
        line.direction = direction;
        line.color = color;
        line.style = style;
    }
    return line;
}

+ (PierLineView *)getLineWithDirection:(PierLineDirection)direction
                                color:(UIColor *)color
                                style:(PierLineStyle)style
                            lineWidth:(CGFloat)width
{
    PierLineView *line = [[PierLineView alloc] init:width];
    if (line) {
        line.direction = direction;
        line.color = color;
        line.style = style;
        
    }
    return line;
    
}

- (void)initial
{
    self.backgroundColor = [UIColor clearColor];
}

- (UIColor *)lineColor
{
    return _color;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _color = lineColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_style == LS_DEFAULT) {
        [_color setFill];
        if (_direction == LD_VERTICAL) {
            CGContextFillRect(context, CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), self.width, CGRectGetHeight(rect)));
        }
        else {
            CGContextFillRect(context, CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), self.width));
        }
    }
    else {
        CGContextSetStrokeColorWithColor(context, _color.CGColor);
        CGContextSetShouldAntialias(context, NO);
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextSetLineDash(context, 0, (CGFloat[]){1, 1}, 1);
        CGContextSetLineWidth(context, 1);
        if (_direction == LD_HORIZONTAL) {
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetMinY(rect));
        } else {
            CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetHeight(rect));
        }
        CGContextStrokePath(context);
    }
}

@end