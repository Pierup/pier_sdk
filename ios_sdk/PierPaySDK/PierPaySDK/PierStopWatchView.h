//
//  PIRStopWatchView.h
//  Pier
//
//  Created by zyma on 2/3/15.
//  Copyright (c) 2015 PIER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIRStopWatchViewDelegate <NSObject>

- (void)timerStop;

@end

@interface PierStopWatchView : UIView

@property (nonatomic, assign) NSInteger expirTime;
@property (nonatomic, weak) id<PIRStopWatchViewDelegate> delegate;

- (void)startTimer;
- (void)stopTimer;

@end
