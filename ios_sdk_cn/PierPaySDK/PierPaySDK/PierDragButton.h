//
//  PIRDragButton.h
//  Pier
//
//  Created by zyma on 11/28/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PierDragButton : UIButton

@property (nonatomic, assign) BOOL dragEnable;

+ (void)addDebugButton;
+ (void)removeDebugButton;

@end
