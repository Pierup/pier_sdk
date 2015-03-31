//
//  PierStopWatchView.m
//  Pier
//
//  Created by zyma on 2/3/15.
//  Copyright (c) 2015 PIER. All rights reserved.
//

#import "PierStopWatchView.h"
#import "PierFont.h"

@interface PierStopWatchView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalSecs;

@property (nonatomic, strong) UILabel *timerLabel;

@end

@implementation PierStopWatchView

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Programmatic Initializer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Setup the view defaults
        [self setupViewDefaults];
    }
    return self;
}

#pragma mark - Nib/Storyboard Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Setup the view defaults
        [self setupViewDefaults];
    }
    return self;
}

- (void)setupViewDefaults{
    self.expirTime = 0;
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_timerLabel setFont:[PierFont customFontWithSize:17]];
    [_timerLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_timerLabel];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)startTimer{
    self.totalSecs = 0;
    __weak typeof(self) weakSelf = self;
    [self updateTimer];//这里不加会延迟1s才显示倒计时
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    [_timerLabel setText:@""];
    [_timer invalidate];
    _timer = nil;
}

- (void)updateTimer{
    [self updateView:1];
}

- (void)updateView:(NSInteger)val
{
    self.totalSecs += val;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger remainSeconds = self.expirTime-self.totalSecs;
        NSInteger second = remainSeconds/60;
        NSString *second_s  = (second < 10) ? [NSString stringWithFormat:@"0%ld",second] : [NSString stringWithFormat:@"%ld",second];
        
        NSInteger minute = remainSeconds%60;
        NSString *minutes_s = (minute < 10) ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
        
        [self.timerLabel setText:[NSString stringWithFormat:@"%@:%@",second_s,minutes_s]];
        if (self.totalSecs == self.expirTime || self.totalSecs > self.expirTime) {
            [self stopTimer];
            [self.delegate timerStop];
        }
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
