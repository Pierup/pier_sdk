//
//  PierTools.h
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/** get pir resources boundle */
NSBundle *pierBoundle();

/** static properities */
static NSBundle *__pierBoundle;

@interface PierTools : NSObject
NSBundle *pierBoundle();
@end
