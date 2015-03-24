//
//  PierAlertView.h
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PierStopWatchView.h"

typedef enum {
    ePierAlertViewType_userInput,
    ePierAlertViewType_warning,
    ePierAlertViewType_error,
    ePierAlertViewType_instance
}ePierAlertViewType;

/** approve block */
typedef BOOL (^approveBlock)(NSString *userInput);
/** cancel block */
typedef void (^cancelBlock)();

@protocol PierAlertViewDelegate <NSObject>

@end

#pragma mark - ---------------------------- PierAlertView ----------------------------

@interface PierAlertView : UIView

/**
 * param
 * name:                Required     Type         Description
 * 1.expiration_time    YES          NSString     SMS ExpirationTime.
 * 2.phone              YES          NSString     User Phone.
 * 3.code_length        YES          NSString     message length.
 * 4.title              YES          NSString     title.
 * 5.approve_text       YES          NSString     approve_text.
 * 6.cancle_text        YES          NSString     cancle_text.
 * 7.title_image_name   YES          NSString     title_image_name.
 */
+ (void)showPierAlertView:(id)delegate
                    param:(id)param
                     type:(ePierAlertViewType)type
                  approve:(approveBlock)approve;

@end

#pragma mark - ---------------------------- PierUserInputAlertView ----------------------------

@interface PierUserInputAlertView : PierAlertView

/**
 * param
 * name:                Required     Type         Description
 * 1.expiration_time    YES          NSString     SMS ExpirationTime.
 * 2.phone              YES          NSString     User Phone.
 * 3.code_length        YES          NSString     message length.
 * 4.title              YES          NSString     title.
 * 5.approve_text       YES          NSString     approve_text.
 * 6.cancle_text        YES          NSString     cancle_text.
 * 7.title_image_name   YES          NSString     title_image_name.
 */
+ (void)showPierUserInputAlertView:(id)delegate
                             param:(id)param
                              type:(ePierAlertViewType)type
                           approve:(approveBlock)approve
                            cancel:(cancelBlock)cancel;

@end


#pragma mark - ---------------------------- PierSMSInputAlertView ----------------------------

@protocol PierSMSInputAlertDelegate <NSObject>

- (void)userApprove:(NSString *)userInput;
- (void)userCancel;
- (void)resendTextMessage;

@end

@interface PierSMSAlertView : PierUserInputAlertView

@property (nonatomic, strong) id<PierSMSInputAlertDelegate> delegate;

/** static api
 * param
 * name:                Required     Type         Description
 * 1.expiration_time    YES          NSString     SMS ExpirationTime.
 * 2.phone              YES          NSString     User Phone.
 * 3.code_length        YES          NSString     message length.
 * 4.title              YES          NSString     title.
 * 5.approve_text       YES          NSString     approve_text.
 * 6.cancle_text        YES          NSString     cancle_text.
 * 7.title_image_name   YES          NSString     title_image_name.
 * 8.amount             Option       NSString     total amount
 *
 */
+ (void)showPierUserInputAlertView:(id)delegate
                             param:(id)param
                              type:(ePierAlertViewType)type
                           approve:(approveBlock)approve
                            cancel:(cancelBlock)cancel;

/** instance api
 * param
 * name:                Required     Type         Description
 * 1.expiration_time    YES          NSString     SMS ExpirationTime.
 * 2.phone              YES          NSString     User Phone.
 * 3.code_length        YES          NSString     message length.
 * 4.title              YES          NSString     title.
 * 5.approve_text       YES          NSString     approve_text.
 * 6.cancle_text        YES          NSString     cancle_text.
 * 7.title_image_name   YES          NSString     title_image_name.
 * 8.amount             Option       NSString     total amount
 *
 */
- (id)initWith:(id)delegate param:(id)param type:(ePierAlertViewType)type;

- (void)show;

- (void)dismiss;

- (void)showErrorMessage:(NSString *)message;

- (void)dismissErorMessage;

- (void)refreshTimer:(id)param;

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