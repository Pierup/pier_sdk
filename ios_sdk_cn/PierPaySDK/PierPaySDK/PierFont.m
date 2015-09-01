//
//  PierFont.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierFont.h"
#import "PierTools.h"
#import <CoreText/CoreText.h>

#define CUSTOM_FONTNAME         @"ProximaNova-Light"
#define CUSTOM_FONTNAME_BOLD    @"ProximaNova-Regular"

@implementation PierFont

+ (UIFont *)customFontWithSize:(CGFloat)size
{
    static UIFont *sCustomFont;
    return [self fontWithCache:sCustomFont
                          name:CUSTOM_FONTNAME
                          size:size];
}




+ (UIFont *)customBoldFontWithSize:(CGFloat)size
{
    static UIFont *sCustomFont;
    return [self fontWithCache:sCustomFont
                          name:CUSTOM_FONTNAME_BOLD
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
        NSString *fontPath = [pierBoundle() pathForResource:name ofType:@"otf"];
        cachedFont = [PierFont customFontWithPath:fontPath size:size];//[UIFont fontWithName:name size:size];
    }
    return cachedFont;
}

+ (UIFont *)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

@end
