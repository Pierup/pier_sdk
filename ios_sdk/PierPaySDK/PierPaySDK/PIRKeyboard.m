//
//  PIRKeyboard.m
//  keyboard
//
//  Created by JHR on 15/1/27.
//  Copyright (c) 2015年 com.homeboy. All rights reserved.
//

#import "PIRKeyboard.h"
#import "PierTools.h"

#define kKeyBoardHeight 216
#define kKeyBoardWidth [[UIScreen mainScreen] bounds].size.width
#define kKeyBoardY     [[UIScreen mainScreen] bounds].size.height
#define kHangShu  4
#define kLieShu   3
#define kLineWidth 0.5
@interface PIRKeyboard()
{
    PIRKeyboard *_view;
    NSString *_number;
}
@end

@implementation PIRKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (PIRKeyboard *)getKeyboardWithType:(keyboardTypeNumber)type delegate:(id)delegate
{
    static PIRKeyboard *__view;
    if (!__view) {
        __view = [[PIRKeyboard alloc] initWithFrame:CGRectMake(0,kKeyBoardY-kKeyBoardHeight,kKeyBoardWidth,kKeyBoardHeight)];
    }
    if (__view) {
        __view.type = type;
        [__view addButton:__view];
        __view.delegate = delegate;
    }
    return __view;
}


- (void)addButton:(PIRKeyboard *)view
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *ColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat buttonWidth = kKeyBoardWidth / kLieShu;
    CGFloat buttonHeight = kKeyBoardHeight / kHangShu;
    for (int i = 0; i < kHangShu;i++)
    {
        for (int j = 0;j < kLieShu;j++)
        {
            UIButton *button = [self creatButtonWithX:i Y:j width:buttonWidth height:buttonHeight highlighted:ColorImg];
            [view addSubview:button];
            _view = view;
        }
    }
    //画线
    UIColor *color = [UIColor grayColor];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth,0, kLineWidth, kKeyBoardHeight)];
    line1.backgroundColor = color;
    [view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth*2,0, kLineWidth,kKeyBoardHeight)];
    line2.backgroundColor = color;
    [view addSubview:line2];
    
    for (int i=0; i<3; i++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,buttonHeight*(i+1), kKeyBoardWidth , kLineWidth)];
        line.backgroundColor = color;
        [view addSubview:line];
    }
    
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
    //
    NSInteger num = y+3*x+1;    // 第几个数
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:86/255.0 green:29/255.0 blue:126/255.0 alpha:1.0]];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setBackgroundImage:img forState:UIControlStateHighlighted];
    if (num < 10) {
        NSString *n = [NSString stringWithFormat:@"%ld",(long)num];
        [button setTitle:n forState:UIControlStateNormal];
    }else if(num == 10) {
        //切换小数点
        if (_type == keyboardTypeNormal) {
            [button setTitle:@"" forState:UIControlStateNormal];
        }else if(_type == keyboardTypePoint){
            [button setTitle:@"." forState:UIControlStateNormal];
        }
    }else if(num == 11){
        NSString *zero = [NSString stringWithFormat:@"0"];
        [button setTitle:zero forState:UIControlStateNormal];
    }
    else if(num == 12){
        CGFloat imageW = 22;
        CGFloat imageH = 17;
        CGFloat x = (width - imageW)/2;
        CGFloat y = (height - imageH)/2;
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,imageW,imageH)];
        UIImage* arrImage = [UIImage imageWithContentsOfFile:getImagePath(@"arrowInKeyboard")];
        arrow.image = arrImage;
        [button addSubview:arrow];
    }
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
    if (btn.tag < 10 ) {   // 1 - 9
        NSString *new = [NSString stringWithFormat:@"%ld",(long)btn.tag];
        if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardInput:)]) {
            [_view.delegate numberKeyboardInput:new];   //当前输入的数字
        }
        _number = [_number stringByAppendingString:new];
        if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardAllInput:)]) {
            [_view.delegate numberKeyboardAllInput:_number];
        }
    }else if(btn.tag == 11){   // 0
        NSString *new = [NSString stringWithFormat:@"0"];
        if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardInput:)]) {
            [_view.delegate numberKeyboardInput:new];   //当前输入的数字
        }
        _number = [_number stringByAppendingString:new];
        if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardAllInput:)]) {
            [_view.delegate numberKeyboardAllInput:_number];
        }
    }else if(btn.tag == 10){   // 小数点
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
        if (_number.length > 0) {
            _number = [_number substringToIndex:_number.length - 1];
            if (_view.delegate && [_view.delegate respondsToSelector:@selector(numberKeyboardAllInput:)]) {
                [_view.delegate numberKeyboardAllInput:_number];
            }
        }
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

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    if (_number) {
        _number = @"";
    }
}
//只能更改坐标不能更改大小
//- (void)setFrame:(CGRect)frame
//{
//    CGRect f = CGRectMake(frame.origin.x, frame.origin.y, kKeyBoardWidth, kKeyBoardHeight);
//    self.frame = f;
//}

@end
