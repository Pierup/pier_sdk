//
//  PierFont.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierFont.h"

#define CUSTOM_FONTNAME         @"Avenir"

@implementation PierFont

+ (UIFont *)customFontWithSize:(CGFloat)size
{
    static UIFont *sCustomFont;
    return [self fontWithCache:sCustomFont
                          name:CUSTOM_FONTNAME
                          size:size];
}

#pragma mark - Private
/*!
 *  Create or reuse a font
 *
 *  @param cachedFont Static variable for caching.
 *  @param name Name of the font.
 *  @param size Size of the font.
 *
 *  @return The font.
 */
+ (UIFont *)fontWithCache:(UIFont *)cachedFont
                     name:(NSString *)name
                     size:(CGFloat)size
{
    if (!cachedFont) {
        cachedFont = [UIFont fontWithName:name size:size];
    }
    return cachedFont;
}

@end
