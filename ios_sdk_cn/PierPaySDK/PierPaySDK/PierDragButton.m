//
//  PIRDragButton.m
//  Pier
//
//  Created by zyma on 11/28/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import "PierDragButton.h"
#import "PierTools.h"
#import "PierDebugView.h"

@interface PierDragButton ()
@property (nonatomic, assign) CGPoint beginPoint;
@end

@implementation PierDragButton

static PierDragButton * __debugBtn = nil;

+ (void)addDebugButton{
    /*调试按钮**/
    if (!__debugBtn) {
        __debugBtn = [[PierDragButton alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        [__debugBtn setCenter:CGPointMake(DEVICE_WIDTH/2, 40)];
        __debugBtn.userInteractionEnabled = YES;
        __debugBtn.dragEnable = YES;
    }
    [__debugBtn removeFromSuperview];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:__debugBtn];
}

+ (void)removeDebugButton{
    [__debugBtn removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self setBackgroundColor:[UIColor redColor]];
        [self setTitle:@"Debug" forState:UIControlStateNormal];
    }
    return self;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture{
    if ([self.titleLabel.text isEqual:@"Debug"]) {
        [[PierDebugView shareInstance] showDebugView];
        [self setTitle:@"Close" forState:UIControlStateNormal];
    }else{
        [[PierDebugView shareInstance] removeDebugView];
        [PierDragButton removeDebugButton];
        [self setTitle:@"Debug" forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    _beginPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - _beginPoint.x;
    float offsetY = nowPoint.y - _beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
