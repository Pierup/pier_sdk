//
//  PierLoadingView.h
//  PierPaySDK
//
//  Created by zyma on 3/8/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PierLoadingView : UIButton

+ (void)showLoadingView:(NSString *)context;
+ (void)hindLoadingView;

@end
