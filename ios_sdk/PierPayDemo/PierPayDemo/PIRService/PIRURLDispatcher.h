//
//  PIRURLDispatcher.h
//  PierPayDemo
//
//  Created by zyma on 3/18/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PIRURLDispatcher : NSObject

@property (nonatomic, strong) UINavigationController *mainNavigationController;

+ (PIRURLDispatcher *)shareInstance;

/**
 * charge
 * name:            Required     Type       Description
 * 1.phone           YES          NSString   user phone.
 * 2.country_code    YES          NSString   the country code of user phone.
 * 3.merchant_id     YES          NSString   your id in pier.
 */
- (void)dispatchURL:(NSURL *)url;

@end
