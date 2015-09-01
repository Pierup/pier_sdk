//
//  PierDebugView.m
//  PierPaySDK
//
//  Created by zyma on 5/11/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierDebugView.h"
#import "PierTools.h"

@interface PierDebugView ()

@property (nonatomic, strong) UITextView *debugView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableString *mutString;

@end

@implementation PierDebugView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (PierDebugView *)shareInstance{
    static PierDebugView * __instance = nil;
    if (!__instance) {
        @synchronized(self){
            if (!__instance) {
                __instance = [[PierDebugView alloc] initWithFrame:CGRectMake(0, 64, DEVICE_WIDTH, 200)];
                [__instance setUpView];
                [__instance setBackgroundColor:[UIColor whiteColor]];
                [__instance setUserInteractionEnabled:YES];
            }
        }
    }
    return __instance;
}

- (void)appendLog:(NSString *)log{
    [self.mutString appendFormat:@"\n\n%@",log];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.debugView setText:self.mutString];
    });
}

- (void)showDebugView{
    [self removeDebugView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:[PierDebugView shareInstance]];
}

- (void)removeDebugView{
    [[PierDebugView shareInstance] removeFromSuperview];
}

- (void)setUpView{
    _mutString = [[NSMutableString alloc] initWithString:@""];
    self.debugView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200)];
    [self.debugView setFont:[UIFont systemFontOfSize:10]];
    [self.debugView setBackgroundColor:[UIColor blackColor]];
    [self.debugView setTextColor:[UIColor whiteColor]];
    [self.debugView setScrollEnabled:YES];
    [self.debugView setUserInteractionEnabled:YES];
    [self.debugView showsVerticalScrollIndicator];
    [self.debugView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.debugView becomeFirstResponder];
    [self addSubview:self.debugView];
}

@end
