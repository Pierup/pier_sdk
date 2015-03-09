//
//  PIRLoadingView.m
//  PierPaySDK
//
//  Created by zyma on 3/8/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierLoadingView.h"
#import "PierTools.h"
#import "PierColor.h"
#import <QuartzCore/QuartzCore.h>

static PierLoadingView * __instances = nil;
static UIView * __loadingBgView;

@interface PierLoadingView ()
@property (nonatomic, strong) NSMutableArray *loadingViewQueue;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) NSMutableArray *activityViewArray;
@property (nonatomic, strong) UIColor *rotatorColor;
@property (nonatomic, assign) CGFloat *rotatorSize;
@property (nonatomic, assign) CGFloat *rotatorSpeed;
@property (nonatomic, assign) CGFloat *rotatorPadding;
@property (nonatomic, copy) NSString *defaultTitle;
@property (nonatomic, copy) NSString *activityTitle;
-(void)startActivity;
-(void)stopActivity;
@end

@implementation PierLoadingView

+ (void)showLoadingView{
    if (__instances == nil) {
        @synchronized(self){
            if (__instances == nil) {
                __instances = [[PierLoadingView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                [__instances setCenter:CGPointMake(DEVICE_WIDTH/2, DEVICE_HEIGHT/2-40)];
                __instances.rotatorColor = [PierColor darkPurpleColor];
                __instances.loadingViewQueue = [[NSMutableArray alloc] initWithCapacity:1];
                
                __loadingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
                [__loadingBgView setBackgroundColor:[UIColor blackColor]];
                [__loadingBgView setAlpha:0.3];
            }
        }
    }
    if (__instances.loadingViewQueue.count>0) {
        [PierLoadingView hindLoadingView];
    }
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [__instances startActivity];
    [window addSubview:__loadingBgView];
    [window addSubview:__instances];
    [__instances.loadingViewQueue addObject:@"TOKEN"];
}

+ (void)hindLoadingView{
    [__instances.loadingViewQueue removeAllObjects];
    [__instances stopActivity];
    [__loadingBgView removeFromSuperview];
    [__instances removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setView];
        _activityViewArray = [[NSMutableArray alloc] initWithCapacity:0];
        _rotatorColor = [UIColor darkGrayColor];
        _rotatorSize   = 0;
        _rotatorSpeed  = 0;
        _rotatorPadding = 0;
        _defaultTitle = @"";
        _activityTitle = @"";
    }
    return self;
}

-(void)setView
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.width);
    self.layer.cornerRadius = self.frame.size.width / 2;
    [self addTarget:self action:@selector(onTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(onTouchDown) forControlEvents:UIControlEventTouchDown];
}

-(void)onTouchUpInside
{
    if(self.activityViewArray.count < 1) {
        [self startActivity];
    }
    
    self.userInteractionEnabled = false;
    self.titleLabel.alpha = 1.0;
}

-(void)onTouchDown
{
    self.titleLabel.alpha = 0.25;
}

-(void)startActivity
{
    int i;
    for (i = 1; i < 900; ++i) {
        UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        activityView.layer.cornerRadius = activityView.frame.size.height / 2;
        activityView.backgroundColor = self.rotatorColor;
        activityView.alpha = 1.0 / (i +0.5);
        [self.activityViewArray addObject:activityView];
    }
    for (UIView *view in self.activityViewArray)
    {
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationLinear;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = false;
        pathAnimation.repeatCount = HUGE;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        pathAnimation.duration = 30;
        CGMutablePathRef curvedPath =CGPathCreateMutable();
        
        long index = [self.activityViewArray indexOfObject:view];
        [self insertSubview:view atIndex:index];
        
        CGFloat startAngle = 270.0 - (index * 4.0);
        CGPathAddArc(curvedPath, nil, self.bounds.origin.x + self.frame.size.width / 2, self.bounds.origin.y + self.frame.size.width / 2, self.frame.size.width / 2 + 0, [self degreesToRadians:startAngle], 360, false);
        pathAnimation.path = curvedPath;
        [view.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
        
    }
}

-(void)stopActivity
{
    for (UIView *view in self.activityViewArray) {
        [view.layer removeAllAnimations];
        [view removeFromSuperview];
    }
    
    [self.activityViewArray removeAllObjects];
    self.userInteractionEnabled = true;
}

-(CGFloat)degreesToRadians:(CGFloat)degrees
{
    CGFloat result = ((degrees) / 180.0 * M_PI);
    return result;
}

#pragma mark - -------------- tools --------------

+ (long)getTimestamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timestamp=[date timeIntervalSince1970];
    long timestamp_i = ceil(timestamp);
    return timestamp_i;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
