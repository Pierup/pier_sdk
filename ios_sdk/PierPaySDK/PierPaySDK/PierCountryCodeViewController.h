//
//  PierCountryCodeViewController.h
//  PierPaySDK
//
//  Created by JHR on 15/3/7.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PierCountryCodeViewController;

typedef NS_ENUM(NSInteger, eCountryType) {
    eCountryType_US,
    eCountryType_CHINA
};

@protocol PierCountryCodeViewControllerDelegate <NSObject>
@optional

- (void)countryCode:(NSString *)countryCode countryName:(NSString *)countryName countryCodeViewController:(PierCountryCodeViewController *)countryCodeViewController;

@end

@interface PierCountryCodeViewController : UIViewController

@property (nonatomic, weak) id<PierCountryCodeViewControllerDelegate>delegate;
@property (nonatomic, assign) eCountryType countryType;

@end

