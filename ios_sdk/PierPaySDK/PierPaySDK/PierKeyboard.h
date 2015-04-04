//
//  PierKeyboard.h
//  keyboard
//
//  Created by JHR on 15/1/27.
//  Copyright (c) 2015年 com.homeboy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger, keyboardTypeNumber)
{
    keyboardTypeNormal,
    keyboardTypePoint
};

@protocol PierKeyboardDelegate <NSObject>
@optional

- (void)numberKeyboardInput:(NSString *)number;            //单次输入的数字
- (void)numberKeyboardAllInput:(NSString *)number;         //所有的输入数字
- (void)numberKeyboardRemoveAllInput;   //删除了所有数字
/** 删除某一个 */
- (void)numberKeyboardRemoveInput:(NSString *)number
                     removeNumber:(NSString *)removeNumber;

@end

@interface PierKeyboard : UIView

@property (nonatomic, assign) keyboardTypeNumber type;           //键盘类型
@property (nonatomic, weak) id<PierKeyboardDelegate>delegate;
@property (nonatomic, assign) NSInteger limitLength;
@property (nonatomic, strong) NSString *number;

+ (PierKeyboard *)getKeyboardWithType:(keyboardTypeNumber)types alpha:(CGFloat)alpha delegate:(id)delegate;

//设置初始值
- (void)setDefaultNumber:(NSString *)number;
//删除所有的输入的数据
- (void)removeAllInput;

@end
