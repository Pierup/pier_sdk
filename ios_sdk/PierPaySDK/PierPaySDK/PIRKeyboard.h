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
- (void)numberKeyboardInput:(NSString *)number;
- (void)numberKeyboardAllInput:(NSString *)number;
- (void)numberKeyboardBackspace:(NSString *)number;

@end

@interface PIRKeyboard : UIView

@property (nonatomic, assign) keyboardTypeNumber type;
@property (nonatomic, assign) id<PIRKeyboardDelegate>delegate;

+ (PIRKeyboard *)getKeyboardWithType:(keyboardTypeNumber)types delegate:(id)delegate;

@end
