//
//  PierAlertView.m
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierAlertView.h"
#import "PierColor.h"
#import "PierTools.h"
#import "PIRKeyboard.h"

@interface PierAlertView ()<PIRKeyboardDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSDictionary *paramDic;
@property (nonatomic, weak) IBOutlet UIButton *approveButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, copy) approveBlock    approveBc;
@property (nonatomic, copy) cancelBlock     cancelBc;

@property (nonatomic, assign) ePierAlertViewType alertType;

/** keyboard */
@property (nonatomic, strong) PIRKeyboard *pirKeyBoard;

@end

@implementation PierAlertView

+ (void)showPierAlertView:(id)delegate param:(id)param type:(ePierAlertViewType)type approve:(approveBlock)approve cancel:(cancelBlock)cancel{
    PierAlertView *confirmView = (PierAlertView *)[[pierBoundle() loadNibNamed:@"PierAlertView" owner:delegate options:nil] objectAtIndex:0];
    confirmView.paramDic    = param;
    confirmView.approveBc   = approve;
    confirmView.cancelBc    = cancel;
    confirmView.alertType   = type;
    [confirmView initData];
    [confirmView initView];
}

- (void)initData{
    
}

- (void)initView{
    UIWindow *currentWindow = [[UIApplication sharedApplication].delegate window];
    CGRect currentBound = [[UIScreen mainScreen] bounds];
//    NSInteger titleViewWidth = 55;
    
    [self.approveButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.approveButton.layer setBorderWidth:1];
    [self.approveButton.layer setCornerRadius:5];
    [self.approveButton.layer setMasksToBounds:YES];
    
    [self.cancelButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.cancelButton.layer setBorderWidth:1];
    [self.cancelButton.layer setCornerRadius:5];
    [self.cancelButton.layer setMasksToBounds:YES];
    
    [self setCenter:CGPointMake(currentBound.size.width/2, currentBound.size.height/2)];
    
    [self.layer setCornerRadius:5];
    [self.layer setMasksToBounds:YES];
    
    self.bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.bgView setBackgroundColor:[UIColor blackColor]];
    [self.bgView setAlpha:0.1];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.bgView setAlpha:0.4];
    }];
    
    
    [currentWindow addSubview:self.bgView];
    [currentWindow addSubview:self];
    
    switch (self.alertType) {
        case ePierAlertViewType_userInput:
        {
            self.pirKeyBoard = [PIRKeyboard getKeyboardWithType:keyboardTypeNormal delegate:self];
            [self setCenter:CGPointMake(currentBound.size.width/2, currentBound.size.height/2 - 100)];
            [currentWindow addSubview:self.pirKeyBoard];
            break;
        }
        default:
            break;
    }
}

- (IBAction)approve:(id)sender{
    [self viewRemoveFromSuperView];
    self.approveBc();
}

- (IBAction)cancelAction:(id)sender{
    [UIView animateWithDuration:0.1 animations:^{
        [self.bgView setAlpha:0.1];
    } completion:^(BOOL finished) {
        [self viewRemoveFromSuperView];
        self.cancelBc();
    }];
}

- (void)handleBgTapGesture{
    [self viewRemoveFromSuperView];
}

- (void)viewRemoveFromSuperView{
    [self.bgView        removeFromSuperview];
    [self.pirKeyBoard   removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - -----------------PIRKeyboardDelegate---------------

- (void)numberKeyboardInput:(NSString *)number{
    
}

- (void)numberKeyboardAllInput:(NSString *)number{
    
}

- (void)numberKeyboardBackspace:(NSString *)number{
    
}

@end
