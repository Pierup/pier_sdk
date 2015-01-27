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
#define kHangShu  4
#define kLieShu   3
@interface PIRKeyboard()
{
    PIRKeyboard  *_view;
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
   PIRKeyboard *view;
   view = [[PIRKeyboard alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-kKeyBoardHeight,kKeyBoardWidth,kKeyBoardHeight)];
    if (view) {
        view.type = type;
        [view addButton:view];
        view.delegate = delegate;
    }
    return view;
}


- (void)addButton:(PIRKeyboard *)view
{
    CGFloat buttonWidth = kKeyBoardWidth / kLieShu;
    CGFloat buttonHeight = kKeyBoardHeight / kHangShu;
    for (int i = 0; i < kHangShu;i++)
    {
        for (int j = 0;j < kLieShu;j++)
        {
            UIButton *button = [self creatButtonWithX:i Y:j width:buttonWidth height:buttonHeight];
            [view addSubview:button];
            _view = view;
        }
    }
}

-(UIButton *)creatButtonWithX:(NSInteger)x Y:(NSInteger)y width:(CGFloat)width height:(CGFloat)height
{
    CGFloat frameX;
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
    [button setBackgroundColor:[UIColor purpleColor]];
    
    if (num < 10) {
        NSString *n = [NSString stringWithFormat:@"%lu",num - 1];
        [button setTitle:n forState:UIControlStateNormal];
           }else if(num == 10) {
        //切换小数点
        if (_type == keyboardTypeNormal) {
            [button setTitle:@"" forState:UIControlStateNormal];
        }else if(_type == keyboardTypePoint){
            [button setTitle:@"." forState:UIControlStateNormal];
        }
           }else if(num == 11){
               NSString *nine = [NSString stringWithFormat:@"9"];
               [button setTitle:nine forState:UIControlStateNormal];
           }
           else if(num == 12){
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(52, 19, 22, 17)];
        UIImage* arrImage = [UIImage imageWithContentsOfFile:getImagePath(@"arrowInKeyboard")];
        arrow.image = arrImage;
        [button addSubview:arrow];
    }
    return button;
}

- (void)clickButton:(UIButton *)btn
{
  //通知代理
    if (!_number) {
        _number = [NSString stringWithFormat:@""];
    }
    if (btn.tag < 10 ) {   // 0 - 8
        NSString *new = [NSString stringWithFormat:@"%ld",(long)btn.tag - 1];
        [_view.delegate numberKeyboardInput:new];   //当前输入的数字
        _number = [_number stringByAppendingString:new];
        [_view.delegate numberKeyboardAllInput:_number];
    }else if(btn.tag == 11){   // 9
        NSString *new = [NSString stringWithFormat:@"%ld",(long)btn.tag - 2];
     [_view.delegate numberKeyboardInput:new];   //当前输入的数字
     _number = [_number stringByAppendingString:new];
    [_view.delegate numberKeyboardAllInput:_number];
    }else if(btn.tag == 10){   // 小数点
        if (_type == keyboardTypeNormal) {
            //不做操作
        }else if(_type == keyboardTypePoint){
           _number = [_number stringByAppendingString:@"."];
            [_view.delegate numberKeyboardInput:@"."];
            [_view.delegate numberKeyboardAllInput:_number];
        }
    }else if(btn.tag == 12){   //删除操作

        if (_number.length > 0) {
            _number = [_number substringToIndex:_number.length - 1];
            [_view.delegate numberKeyboardBackspace:_number];
        }
    }
}

//只能更改坐标不能更改大小
//- (void)setFrame:(CGRect)frame
//{
//    CGRect f = CGRectMake(frame.origin.x, frame.origin.y, kKeyBoardWidth, kKeyBoardHeight);
//    self.frame = f;
//}

@end
