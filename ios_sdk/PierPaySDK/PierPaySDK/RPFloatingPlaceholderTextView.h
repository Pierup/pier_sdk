//
//  RPFloatingPlaceholderTextView.h
//  RPFloatingPlaceholders
//
//  Created by Rob Phillips on 10/19/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//
//  See LICENSE for full license agreement.
//

#import <UIKit/UIKit.h>
#import "RPFloatingPlaceholderConstants.h"

@interface RPFloatingPlaceholderTextView : UITextView

/**
 Enum to switch between upward and downward animation of the floating label.
 */
@property (nonatomic) RPFloatingPlaceholderAnimationOptions animationDirection;

/**
 The string that is displayed when there is no other text in the text view.
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 The floating label that is displayed above the text view when there is other 
 text in the text view.
 */
@property (nonatomic, strong, readonly) UILabel *floatingLabel;

/**
 The color of the floating label displayed above the text view when it is in
 an active state (i.e. the associated text view is first responder).
 
 @discussion Note: Tint color is used by default if this is nil.
 */
@property (nonatomic, strong) UIColor *floatingLabelActiveTextColor;

/**
 The color of the floating label displayed above the text view when it is in
 an inactive state (i.e. the associated text view is not first responder).
 
 @discussion Note: 70% gray is used by default if this is nil.
 */
@property (nonatomic, strong) UIColor *floatingLabelInactiveTextColor;

@end
