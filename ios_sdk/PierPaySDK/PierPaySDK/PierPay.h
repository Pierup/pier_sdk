//
//  PierPaySDK.h
//  PierPaySDK
//
//  Created by zyma on 12/3/14.
//  Copyright (c) 2014 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PayByPierDelegate <NSObject>

@required
/**
 * Result
 * name:        Type            Description
 * 1.status     NSNumber        Showing the status of sdk execution.It means successful if is true,else means fail.
 * 2.message    NSString        Showing the message from pier.
 * 3.code       NSNumber        Showing the code of message from pier.
 * 4.result     NSDictionary    Showing the value of output params of pier.
 */
-(void)payByPierComplete:(NSDictionary *)result;

@end

@interface UserAttribute : NSObject

@end

#pragma mark - navigationController
@interface PierPay : UINavigationController

@property (nonatomic, weak) id<PayByPierDelegate> pierDelegate;

/**
 * userAttributes
 * name:            Required     Type       Description
 * 1.name           YES          NSString   user name
 * 2.phone          YES          NSString   user phone
 * 3.country_code   YES          NSString   the country code of user phone.
 */
- (instancetype)initWith:(NSDictionary *)userAttributes;

@end