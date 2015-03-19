//
//  PierTools.h
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEVICE_WIDTH    [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT   [UIScreen mainScreen].bounds.size.height

@interface PierTools : NSObject

/** get pir resources boundle */
NSBundle *pierBoundle();

/** Get iPhone Version */
double PIER_IPHONE_OS_MAIN_VERSION();
/** Get ImageName in Bundle */
NSString *getImagePath(NSString *imageName);

/** --- */
+ (CGFloat)keyboardHeight;

@end
