//
//  PierCountryCodeViewController.h
//  PierPaySDK
//
//  Created by JHR on 15/3/7.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PierPayModel.h"

@interface PierCountryModel : NSObject

@property (nonatomic, copy) NSString *name;                // UNITED STATES
@property (nonatomic, copy) NSString *phone_prefix;        // 1
@property (nonatomic, copy) NSString *phone_size;          // 10
@property (nonatomic, copy) NSString *country_code;        // US

@end

@protocol PierCountryCodeViewControllerDelegate <NSObject>
@optional

- (void)countryCodeWithCountry:(PierCountry *)country;

@end

@interface PierCountryCodeViewController : UIViewController

@property (nonatomic, weak) id<PierCountryCodeViewControllerDelegate>delegate;
@property (nonatomic, strong) PierCountryModel *selectedCountryModel;

@end
