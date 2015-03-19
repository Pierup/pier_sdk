//
//  PierStopWatchView.h
//  Pier
//
//  Created by zyma on 2/3/15.
//  Copyright (c) 2015 PIER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PierStopWatchViewDelegate <NSObject>

- (void)timerStop;

@end

@interface PierStopWatchView : UIView

@property (nonatomic, assign) NSInteger expirTime;
@property (nonatomic, weak) id<PierStopWatchViewDelegate> delegate;

- (void)startTimer;
- (void)stopTimer;

@end
