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


@interface PierSMSAlertView : PierUserInputAlertView

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

//@interface PierCustomKeyboardAlertView : UIView
//
//+ (void)showPierAlertView:(id)delegate
//                    param:(id)param
//                     type:(ePierAlertViewType)type
//                  approve:(approveBlock)approve
//                   cancel:(cancelBlock)cancel;
//
//@end