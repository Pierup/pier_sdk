//
//  PierColor.m
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierColor.h"

@implementation PierColor

+ (UIColor *)darkPurpleColor{
    return PierColorHex(0x571780);
}

+ (UIColor *)lightPurpleColor{
    return PierColorHex(0x7b37a6);
}

+ (UIColor *)lightGreenColor{
    return PierColorHex(0x37d6cf);
}

+ (UIColor *)whiteAlphaColor{
    return PierColorHex(0x9463b5);
}

/**
 *  #dcdcdc
 */
+ (UIColor *)placeHolderColor{
    return PierColorHex(0xdcdcdc);
}

@end
