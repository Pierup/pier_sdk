//
//  PierAlertView.h
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ePierAlertViewType_userInput,
    ePierAlertViewType_warning,
    ePierAlertViewType_error
}ePierAlertViewType;

/** approve block */
typedef void (^approveBlock)();
/** cancel block */
typedef void (^cancelBlock)();

@protocol PierAlertViewDelegate <NSObject>

- (void)approveButton;

@end

@interface PierAlertView : UIView

+ (void)showPierAlertView:(id)delegate
                    param:(id)param
                     type:(ePierAlertViewType)type
                  approve:(approveBlock)approve
                   cancel:(cancelBlock)cancel;

@end
