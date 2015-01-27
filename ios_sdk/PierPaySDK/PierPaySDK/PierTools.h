//
//  PierTools.h
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PierTools : NSObject

/** get pir resources boundle */
NSBundle *pierBoundle();

/** Get iPhone Version */
double IPHONE_OS_MAIN_VERSION();
/** Get ImageName in Bundle */
NSString *getImagePath(NSString *imageName);

@end
