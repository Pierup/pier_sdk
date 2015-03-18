//
//  PIRURLDispatcher.m
//  PierPayDemo
//
//  Created by zyma on 3/18/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PIRURLDispatcher.h"

@implementation PIRURLDispatcher

/**
 * userAttributes
 * name:            Required     Type       Description
 * 1.phone           YES          NSString   user phone.
 * 2.country_code    YES          NSString   the country code of user phone.
 * 3.merchant_id     YES          NSString   your id in pier.
 */
+ (void)dispatchURL:(NSURL *)url{
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
}

+ (void)parseURL:(NSURL *)url{
    
}
@end
