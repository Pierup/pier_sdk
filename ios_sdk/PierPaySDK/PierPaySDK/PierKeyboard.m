//
//  PierKeyboard.m
//  keyboard
//
//  Created by JHR on 15/1/27.
//  Copyright (c) 2015年 com.homeboy. All rights reserved.
//

#import "PierKeyboard.h"
#import "PierTools.h"
#import "PierColor.h"
#import "PierFont.h"
#import <limits.h>

#define kKeyBoardWidth [[UIScreen mainScreen] bounds].size.width
#define kKeyBoardY     [[UIScreen mainScreen] bounds].size.height
#define kHangShu  4
#define kLieShu   3
#define kLineWidth .3
@interface PierKeyboard()

@property (nonatomic, strong) PierKeyboard *view;

@end

@implementation PierKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (PierKeyboard *)getKeyboardWithType:(keyboardTypeNumber)type alpha:(CGFloat)alpha delegate:(id)delegate
{
    PierKeyboard *view;
    if (!view) {
        view = [[PierKeyboard alloc] initWithFrame:CGRectMake(0,0, kKeyBoardWidth, [PierTools keyboardHeight])];
    }
    
    if (view) {
        view.type = type;
        if (alpha) {
            view.alpha = alpha;
        }
        [view addButton:view alpha:alpha];
        view.backgroundColor = [PierColor darkPurpleColor];
        view.alpha = alpha;
        view.delegate = delegate;
    }
    view.limitLength = INT_MAX;
    return view;
}


- (void)addButton:(PierKeyboard *)view alpha:(CGFloat)alpha
{
    //    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    UIGraphicsBeginImageContext(rect.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [[PierColor lightPurpleColor] CGColor]);
    //    CGContextFillRect(context, rect);
    //    UIImage *ColorImg = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    CGFloat buttonWidth = kKeyBoardWidth / kLieShu;
    CGFloat buttonHeight = [PierTools keyboardHeight] / kHangShu;
    for (int i = 0; i < kHangShu;i++)
    {
        for (int j = 0;j < kLieShu;j++)
        {
            UIButton *button = [self creatButtonWithX:i Y:j width:buttonWidth height:buttonHeight highlighted:nil];
            if (alpha) {
                button.alpha = alpha;
            }
            [view addSubview:button];
            _view = view;
        }
    }
    //画线
    UIColor *color = [PierColor lightPurpleColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,0, kKeyBoardWidth, kLineWidth)];
    line.backgroundColor = color;
    [view addSubview:line];
    //    UIColor *color = [PierColor lineColor];
    //    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth,0, kLineWidth, kKeyBoardHeight)];
    //    line1.backgroundColor = color;
    //    [view addSubview:line1];
    //
    //    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth*2,0, kLineWidth,kKeyBoardHeight)];
    //    line2.backgroundColor = color;
    //    [view addSubview:line2];
    //
    //    for (int i=0; i<3; i++)
    //    {
    //        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,buttonHeight*(i+1), kKeyBoardWidth , kLineWidth)];
    //        line.backgroundColor = color;
    //        [view addSubview:line];
    //    }
    
}

-(UIButton *)creatButtonWithX:(NSInteger)x Y:(NSInteger)y width:(CGFloat)width height:(CGFloat)height highlighted:(UIImage *)img
{
    CGFloat frameX = 0.0;
    switch (y) {
        case 0:
            frameX = 0;
            break;
        case 1:
            frameX = width*1;
            break;
        case 2:
            frameX = width*2;
            break;
        default:
            break;
    }
    CGFloat frameY = height*x;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frameX,frameY, width,height)];
    NSInteger num = y+3*x+1;    // 第几个数
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(animationButtonOutside:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(animationButtonOutside:) forControlEvents:UIControlEventTouchDragExit];
    
    //    [button setBackgroundColor:[PierColor darkPurpleColor]];
    button.titleLabel.font = [PierFont customFontWithSize:25];
    //    [button setBackgroundImage:img forState:UIControlStateHighlighted];
    if (num < 10) {
        NSString *n = [NSString stringWithFormat:@"%ld",num];
        [button setTitle:n forState:UIControlStateNormal];
    }else if(num == 10) {
        //切换小数点
        if (_type == keyboardTypeNormal) {
            button.enabled = NO;
            [button setTitle:@"" forState:UIControlStateNormal];
        }else if(_type == keyboardTypePoint){
            button.enabled = YES;
            [button setTitle:@"." forState:UIControlStateNormal];
        }
    }else if(num == 11){
        NSString *zero = [NSString stringWithFormat:@"0"];
        [button setTitle:zero forState:UIControlStateNormal];
    }
    else if(num == 12){
        CGFloat imageW = 22;
        CGFloat imageH = 22;
        CGFloat x = (width - imageW)/2;
        CGFloat y = (height - imageH)/2;
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,imageW,imageH)];
//        arrow.image = [UIImage imageNamed:@"keypaddelete@2x.png" inBundle:pierBoundle() compatibleWithTraitCollection:nil];
        arrow.image = [UIImage imageWithContentsOfFile:getImagePath(@"keypaddelete")];
        [button addSubview:arrow];
    }
    button.backgroundColor = [UIColor clearColor];
    return button;
}

#pragma mark ---------------------Delegate --------------------------
#pragma mark ----button action
- (void)clickButton:(UIButton *)btn
{
    //通知代理
    if (!_number) {
        _number = [NSString stringWithFormat:@""];
    }
    if (_number.length < self.limitLength) {
        if (btn.tag < 10 ) {   // 1 - 9
            [self animationButton:btn];
            NSString *new = [NSString stringWithFormat:@"%ld",(long)btn.tag];
            if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardInput:)]) {
                [_view.delegate numberKeyboardInput:new];   //当前输入的数字
            }
            _number = [_number stringByAppendingString:new];
            if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardAllInput:)]) {
                [_view.delegate numberKeyboardAllInput:_number];
            }
        }else if(btn.tag == 11){   // 0
            [self animationButton:btn];
            NSString *new = [NSString stringWithFormat:@"0"];
            if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardInput:)]) {
                [_view.delegate numberKeyboardInput:new];   //当前输入的数字
            }
            _number = [_number stringByAppendingString:new];
            if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardAllInput:)]) {
                [_view.delegate numberKeyboardAllInput:_number];
            }
        }else if(btn.tag == 10){   // 小数点
            [self animationButton:btn];
            if (_type == keyboardTypeNormal) {
                //不做操作
            }else if(_type == keyboardTypePoint){
                _number = [_number stringByAppendingString:@"."];
                if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardInput:)]) {
                    [_view.delegate numberKeyboardInput:@"."];
                }
                if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardAllInput:)]) {
                    [_view.delegate numberKeyboardAllInput:_number];
                }
            }
        }else if(btn.tag == 12){   //删除操作
            [self animationButton:btn];
            if (_number.length > 0) {
                NSString *lastField = [_number substringFromIndex:_number.length - 1];
                _number = [_number substringToIndex:_number.length - 1];
                if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardRemoveInput:removeNumber:)]) {
                    [_view.delegate numberKeyboardRemoveInput:_number removeNumber:lastField];
                }
                if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardAllInput:)]) {
                    [_view.delegate numberKeyboardAllInput:_number];
                }
            }
        }
    }else if (_number.length == self.limitLength) {
        [self animationButton:btn];
        if(btn.tag == 12){   //删除操作
            if (_number.length > 0) {
                NSString *lastField = [_number substringFromIndex:_number.length - 1];
                _number = [_number substringToIndex:_number.length - 1];
                if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardRemoveInput:removeNumber:)]) {
                    [_view.delegate numberKeyboardRemoveInput:_number removeNumber:lastField];
                }
                if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardAllInput:)]) {
                    [_view.delegate numberKeyboardAllInput:_number];
                }
            }
        }else{
            return;
        }
    }else{
        return;
    }
}

- (void)removeAllInput
{
    if (_number) {
        _number = @"";
        if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardRemoveAllInput)]) {
            [_view.delegate numberKeyboardRemoveAllInput];
        }
    }
}

//设置初始值
- (void)setDefaultNumber:(NSString *)number{
    _number = number;
}


- (void)removeFromSuperview
{
    [super removeFromSuperview];
    if (_number) {
        _number = @"";
    }
}


//放大缩小动画
- (void)animationButton:(UIButton *)button
{
    CGFloat scale = 2.2;
    //    if (button.tag == 12) {
    //            scale = scale - 0.5;
    //    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:self];
    button.transform = CGAffineTransformScale([self transformForOrientation], scale, scale);
    [UIView commitAnimations];
    
    
}

- (void)animationButtonOutside:(UIButton *)button{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDelegate:self];
    button.transform = CGAffineTransformScale([self transformForOrientation], 1.0, 1.0);
    [UIView commitAnimations];
    
}

- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationLandscapeLeft == orientation) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (UIInterfaceOrientationLandscapeRight == orientation) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

@end
