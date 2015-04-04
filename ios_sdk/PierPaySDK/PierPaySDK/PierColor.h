//
//  PierColor.h
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** RGB颜色 */
#define PierColorRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define PierColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/** HEX颜色 */
#define PierColorHex(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:1.0]
#define PierColorHexA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:(a)]

@interface PierColor : NSObject

/**
 *  深紫色（按钮正常状态）
 */
+ (UIColor *)darkPurpleColor;

/**
 *  浅紫色 C1
 */
+ (UIColor *)lightPurpleColor;

+ (UIColor *)lightGreenColor;

/**
 *  灰色文字颜色
 *  #9463b5
 */
+ (UIColor *)whiteAlphaColor;

/** 
 *  #dcdcdc
 */
+ (UIColor *)placeHolderColor;

@end
