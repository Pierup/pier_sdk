//
//  PIRKeyboard.h
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

@protocol PIRKeyboardDelegate <NSObject>
@optional

- (void)numberKeyboardInput:(NSString *)number;            //单次输入的数字
- (void)numberKeyboardAllInput:(NSString *)number;         //所有的输入数字
- (void)numberKeyboardRemoveAllInput;   //删除了所有数字

@end

@interface PIRKeyboard : UIView

@property (nonatomic, assign) keyboardTypeNumber type;           //键盘类型
@property (nonatomic, assign) id<PIRKeyboardDelegate>delegate;

+ (PIRKeyboard *)getKeyboardWithType:(keyboardTypeNumber)types delegate:(id)delegate;

//删除所有的输入的数据
- (void)removeAllInput;
@end
