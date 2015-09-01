//
//  PierDebugView.h
//  PierPaySDK
//
//  Created by zyma on 5/11/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PierDebugView : UIView

+ (PierDebugView *)shareInstance;
- (void)appendLog:(NSString *)log;
- (void)showDebugView;
- (void)removeDebugView;

@end
