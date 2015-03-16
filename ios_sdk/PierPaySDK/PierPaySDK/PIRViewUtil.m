//
//  PIRViewUtil.m
//  Pier
//
//  Created by zyma on 11/19/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import "PIRViewUtil.h"
#import <CoreImage/CoreImage.h>
#import "PierColor.h"
#import "PierTools.h"
#import <math.h>

@implementation PIRViewUtil

+ (void)horizonView:(UIView *)view{
    CGAffineTransform at_scanRemark =CGAffineTransformMakeRotation(M_PI/2);
    at_scanRemark =CGAffineTransformTranslate(at_scanRemark,0,0);
    [view setTransform:at_scanRemark];
}

+ (void)drawSeparotorLineTab:(UIView *)view{
    PIRLineView *line = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(15, view.bounds.size.height, [[UIScreen mainScreen]bounds].size.width-15, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLineTab:(UIView *)view withColor:(UIColor *)color{
    PIRLineView *line = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:color style:LS_DEFAULT];
    [line setFrame:CGRectMake(15, view.bounds.size.height, [[UIScreen mainScreen]bounds].size.width-15, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLine:(UIView *)view{
    PIRLineView *line = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(0, view.bounds.size.height, view.bounds.size.width, 1)];
    [view addSubview:line];
}

+ (void)drawScreenSeparotorLine:(UIView *)view{
    PIRLineView *line = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(0, view.bounds.size.height, [[UIScreen mainScreen]bounds].size.width, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLine15:(UIView *)view{
    PIRLineView *line = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(15, view.bounds.size.height, view.bounds.size.width-30, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLineTop:(UIView *)view{
    PIRLineView *line = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    [view addSubview:line];
}

+ (void)drawSeparotorLineVerticalCenter:(UIView *)view
{
    PIRLineView *line = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [line setFrame:CGRectMake(0, view.bounds.size.height/2, [[UIScreen mainScreen]bounds].size.width, 1)];
    [view addSubview:line];
}

+ (void)drawRectLine:(UIView *)view{
    PIRLineView *bottomline = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [bottomline setFrame:CGRectMake(0, 0, view.bounds.size.width, 1)];
    [view addSubview:bottomline];
    
    PIRLineView *topLine = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor blackColor] style:LS_DEFAULT];
    [topLine setFrame:CGRectMake(0, view.bounds.size.height - 1, view.bounds.size.width, 1)];
    [view addSubview:topLine];
    
    PIRLineView *leftLine = [PIRLineView getLineWithDirection:LD_VERTICAL color:[UIColor blackColor] style:LS_DEFAULT];
    [leftLine setFrame:CGRectMake(0, 0, 1, view.bounds.size.height)];
    [view addSubview:leftLine];
    
    PIRLineView *rightLine = [PIRLineView getLineWithDirection:LD_VERTICAL color:[UIColor blackColor] style:LS_DEFAULT];
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
    [view setBackgroundColor:PIRColorRGB(121, 60, 162)];
    int lineCount = DEVICE_WIDTH/4;
    for (int i = 0; i < lineCount; i++) {
        PIRLineView *line = [PIRLineView getLineWithDirection:LD_VERTICAL color:[UIColor blackColor] style:LS_DEFAULT lineWidth:2];
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
@end

@interface PIRLineView ()
@property(nonatomic, assign) CGFloat width;
@end

@implementation PIRLineView

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

+ (PIRLineView *)getLineWithDirection:(PIRLineDirection)direction
                                color:(UIColor *)color
                                style:(PIRLineStyle)style
{
    PIRLineView *line = [[PIRLineView alloc] init];
    if (line) {
        line.direction = direction;
        line.color = color;
        line.style = style;
    }
    return line;
}

+ (PIRLineView *)getLineWithDirection:(PIRLineDirection)direction
                                color:(UIColor *)color
                                style:(PIRLineStyle)style
                            lineWidth:(CGFloat)width
{
    PIRLineView *line = [[PIRLineView alloc] init:width];
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

@implementation UIView (Effects)

- (void)blur{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 15] forKey: @"inputRadius"];
    CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
    
    CGImageRef cgImage = [context createCGImage:resultImage fromRect:self.bounds];
    UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.tag = -1;
    imageView.image = blurredImage;
    
    UIView *overlay = [[UIView alloc] initWithFrame:self.bounds];
    overlay.tag = -2;
    overlay.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    
    [self addSubview:imageView];
    [self addSubview:overlay];
}

-(void)unBlur{
    [[self viewWithTag:-1] removeFromSuperview];
    [[self viewWithTag:-2] removeFromSuperview];
}

@end

@interface PIRBlockSchemeView ()
@property (nonatomic, strong) PIRLineView *rightTopLine;
@property (nonatomic, strong) PIRLineView *leftTopLine;
@property (nonatomic, strong) PIRLineView *leftArrorLine;
@property (nonatomic, strong) PIRLineView *rightArrorLine;
@property (nonatomic, strong) PIRLineView *bottomLine;

@property (nonatomic, assign) CGFloat _viewHeight;
@property (nonatomic, assign) CGFloat _topLineWidth;
@property (nonatomic, assign) CGFloat _arrowLineWidth;
@property (nonatomic, assign) CGFloat _height;
@property (nonatomic, assign) CGFloat _topArrowLineWidth;
@end

@implementation PIRBlockSchemeView

+ (PIRBlockSchemeView *)getBlockSchemWithHeight:(CGFloat)height OriginX:(CGFloat)x OriginY:(CGFloat)y LineWidth:(CGFloat)width
{
    //父类View
    PIRBlockSchemeView *view = [[PIRBlockSchemeView alloc]init];
    CGFloat offSetX = 0;   //在父视图的位置
    CGFloat offSetY = y;
    CGFloat schemWidth = [[UIScreen mainScreen]bounds].size.width;
    CGFloat schemHeight = 15;
    view.frame = CGRectMake(offSetX,offSetY, schemWidth, schemHeight);
    view.backgroundColor = [UIColor clearColor];
    //箭头长度
    CGFloat arrowLineWidth = 21;
    CGFloat topArrowLineWidth =hypot(arrowLineWidth, arrowLineWidth);  //三角形底部的长度
    CGFloat topLineWidth = (schemWidth - topArrowLineWidth) / 2;
    
    view._topLineWidth = topLineWidth;
    view._height = height;
    view._viewHeight = CGRectGetHeight(view.frame);
    view._arrowLineWidth = arrowLineWidth;
    view._topArrowLineWidth = topArrowLineWidth;
    
    PIRLineView *rightTopLine = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor redColor] style:LS_DEFAULT lineWidth:width];
    rightTopLine.frame = CGRectMake(0,view._viewHeight,topLineWidth + 1,width);
    [view.layer addSublayer:rightTopLine.layer];
    view.rightTopLine = rightTopLine;
    
    PIRLineView *leftTopLine = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor redColor] style:LS_DEFAULT lineWidth:width];
    leftTopLine.frame = CGRectMake(topLineWidth + topArrowLineWidth - 1,view._viewHeight,topLineWidth + 1,width);
    [view.layer addSublayer:leftTopLine.layer];
    view.leftTopLine = leftTopLine;
    
    //箭头
    PIRLineView *leftArrorLine = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor redColor] style:LS_DEFAULT lineWidth:width];
    leftArrorLine.frame = CGRectMake(topLineWidth - 10,view._viewHeight,arrowLineWidth,width);
    leftArrorLine.layer.anchorPoint = CGPointMake(1.0,0.5);
    [leftArrorLine setTransform:CGAffineTransformMakeRotation(M_PI/4*3)];
    [view.layer addSublayer:leftArrorLine.layer];
    view.leftArrorLine = leftArrorLine;
    
    PIRLineView *rightArrorLine = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor redColor] style:LS_DEFAULT lineWidth:width];
    rightArrorLine.frame = CGRectMake(topLineWidth + topArrowLineWidth/2 + 4,view._viewHeight,arrowLineWidth,width);
    rightArrorLine.layer.anchorPoint = CGPointMake(1.0,0.5);
    [rightArrorLine setTransform:CGAffineTransformMakeRotation(M_PI/4)];
    [view.layer addSublayer:rightArrorLine.layer];
    view.rightArrorLine = rightArrorLine;
    
    //底部画线
    PIRLineView *bottomLine = [PIRLineView getLineWithDirection:LD_HORIZONTAL color:[UIColor redColor] style:LS_DEFAULT lineWidth:width];
    bottomLine.frame = CGRectMake(0, view._viewHeight + height, schemWidth, width);
    [view.layer addSublayer:bottomLine.layer];
    view.bottomLine = bottomLine;
    return view;
    
}

- (void)setSchemeLineColor:(UIColor *)color
{
    self.rightTopLine.color = color;
    [self.rightTopLine setNeedsDisplay];
    self.leftTopLine.color = color;
    [self.leftTopLine setNeedsDisplay];
    self.leftArrorLine.color = color;
    [self.leftArrorLine setNeedsDisplay];
    self.rightArrorLine.color = color;
    [self.rightArrorLine setNeedsDisplay];
    self.bottomLine.color = color;
    [self.bottomLine setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制填充三角形
    CGContextMoveToPoint(context,self._topLineWidth + 0.9, self._viewHeight);
    CGFloat arrowY = sin(45.f) * self._arrowLineWidth - 4;
    CGContextAddLineToPoint(context, self._topLineWidth  + (self._topArrowLineWidth/2) + 0.2, self._viewHeight - arrowY + 0.5);
    CGContextAddLineToPoint(context, self._topLineWidth + self._topArrowLineWidth - 1,self._viewHeight);
    [[UIColor whiteColor] setStroke];   //画线颜色
    CGContextClosePath(context);        //路径结束标志,不写默认封闭
    [[UIColor whiteColor] setFill];    //填充颜色
    CGContextDrawPath(context,kCGPathFillStroke);//绘制路径path
}

@end