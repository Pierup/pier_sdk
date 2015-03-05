//
//  PierAlertView.h
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIRStopWatchView.h"

typedef enum {
    ePierAlertViewType_userInput,
    ePierAlertViewType_warning,
    ePierAlertViewType_error
}ePierAlertViewType;

/** approve block */
typedef void (^approveBlock)(NSString *userInput);
/** cancel block */
typedef void (^cancelBlock)();

@protocol PierAlertViewDelegate <NSObject>

@end

#pragma mark - ---------------------------- PierAlertView ----------------------------
@interface PierAlertView : UIView

@property (nonatomic, copy) NSString *titleImageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *alertText;
@property (nonatomic, copy) NSString *doneText;

+ (void)showPierAlertView:(id)delegate
                    param:(id)param
                     type:(ePierAlertViewType)type
                  approve:(approveBlock)approve;

@end

#pragma mark - ---------------------------- PierUserInputAlertView ----------------------------
@interface PierUserInputAlertView : PierAlertView

@property (nonatomic, copy) NSString *titleImageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *approveText;
@property (nonatomic, copy) NSString *cancleText;


+ (void)showPierUserInputAlertView:(id)delegate
                             param:(id)param
                              type:(ePierAlertViewType)type
                           approve:(approveBlock)approve
                            cancel:(cancelBlock)cancel;

@end

#pragma mark - ---------------------------- PierUserInputAlertView ----------------------------
@interface PierSMSAlertView : PierUserInputAlertView

+ (void)showPierUserInputAlertView:(id)delegate
                             param:(id)param
                              type:(ePierAlertViewType)type
                           approve:(approveBlock)approve
                            cancel:(cancelBlock)cancel;

@end

//@interface PierCustomKeyboardAlertView : UIView
//
//+ (void)showPierAlertView:(id)delegate
//                    param:(id)param
//                     type:(ePierAlertViewType)type
//                  approve:(approveBlock)approve
//                   cancel:(cancelBlock)cancel;
//
//@end