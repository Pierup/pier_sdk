//
//  NSString+Check.m
//  Pier
//
//  Created by zyma on 10/30/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import "NSString+PierCheck.h"
#import "PierDateUtil.h"

@implementation NSString (PierCheck)

+ (BOOL)emptyOrNull:(NSString *)str
{
    return str == nil || (NSNull *)str == [NSNull null] || str.length == 0;
}


+ (NSString *)getUnNilString:(NSString *)str{
    NSString *result = @"";
    if ([NSString emptyOrNull:str]) {
        result = @"";
    }else{
        result = str;
    }
    return result;
}

+ (BOOL)arrayEmptyOrNull:(NSArray *)array
{
    return array == nil || (NSNull *)array == [NSNull null] || [array count] < 1;
}

- (bool)isNumString
{
    NSString *match=@"[0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    bool valid = [predicate evaluateWithObject:self];
    return valid;
}

- (bool)isEnString
{
    NSString *match=@"[\\s]*[A-Za-z]+[\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)isStringOnlyEnOrNum
{
    NSString *match = @"[A-Za-z0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    return [predicate evaluateWithObject:self];
}

- (bool)isValidCN
{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    return [predicate evaluateWithObject:self];
}

- (bool)isValidEMail
{
    NSString *match=@"\\S+@(\\S+\\.)+[\\S]{1,6}";
    //  NSString *match=@"[a-zA-Z0-9_.-]+@([a-zA-Z0-9]+\\.)+[a-zA-Z]{1,6}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    bool valid = [predicate evaluateWithObject:self];
    
    return valid;
}

- (eDOBFormate)checkDOBFormate{
    eDOBFormate result = eDOBFormate_invalid;
    NSDate *dobData = [PierDateUtil dateFromString:self formate:SIMPLEFORMATTYPESTRING14];
    NSInteger age = [PierDateUtil calculateAgeWithBirthdate:dobData];
    
    if (dobData) {
        if (age < 18) {
            result = eDOBFormate_less18;
        }else if (age > 120){
            result = eDOBFormate_more120;
        }else{
            result = eDOBFormate_available;
        }
    }else{
        result = eDOBFormate_invalid;
    }
    return result;
}

/**
 * isValudSSN
 */
- (BOOL)isValudSSN{
    if ([self length]==9) {
        NSMutableString *formateSSN = [[NSMutableString alloc] init];
        [formateSSN appendString:[self substringToIndex:3]];
        NSRange range2 = NSMakeRange(3, 2);
        NSRange range3 = NSMakeRange(5, 4);
        [formateSSN appendFormat:@"-%@-",[self substringWithRange:range2]];
        [formateSSN appendFormat:@"%@",[self substringWithRange:range3]];
        
        NSString *re = @"^(?!219099999|078051120)(?!666|000|9\\d{2})\\d{3}(?!00)\\d{2}(?!0{4})\\d{4}$";
        NSString *reWithDash =@"^(?!\\b(\\d)\1+-(\\d)\\1+-(\\d)\\1+\\b)(?!123-45-6789|219-09-9999|078-05-1120)(?!666|000|9\\d{2})\\d{3}-(?!00)\\d{2}-(?!0{4})\\d{4}$";
        NSPredicate *predicate_re = [NSPredicate predicateWithFormat:@"SELF matches %@", re];
        NSPredicate *predicate_reWithDash = [NSPredicate predicateWithFormat:@"SELF matches %@", reWithDash];
        
        return ([predicate_re evaluateWithObject:formateSSN] || [predicate_reWithDash evaluateWithObject:formateSSN]);
    }else{
        return NO;
    }
}

- (int)strByteLength
{
    if(self == nil || [self isEqualToString:@""])
    {
        return 0;
    }
    
    int len = 0;
    
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    
    for (unsigned int i = 0 ; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++)
    {
        if (*p)
        {
            p++;
            len++;
        }
        else
        {
            p++;
        }
    }
    
    return len;
}

#pragma mark 判断string是否包含aString
- (BOOL)isContainString:(NSString *)subString
{
    NSRange range = [[self lowercaseString] rangeOfString:[subString lowercaseString]];
    return range.location != NSNotFound;
}

- (NSString *)phoneFormat
{
    NSMutableString *phoneFormat = [NSMutableString stringWithString:self];;
    switch (self.length) {
        case 10:
        {
            [phoneFormat insertString:@"(" atIndex:0];
            [phoneFormat insertString:@")" atIndex:4];
            [phoneFormat insertString:@"-" atIndex:8];
            break;
        }
        case 11:
        {
            [phoneFormat insertString:@"-" atIndex:3];
            [phoneFormat insertString:@"-" atIndex:8];
            break;
        }
        default:
            break;
    }
    return phoneFormat;
}

- (NSString *)phoneClearFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"(" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@")" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return result;
}

+ (NSString *)getNumbers:(NSString*)stirng{
    NSUInteger len = [stirng length];
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (int i = 0; i < len; i++) {
        NSString *s = [stirng substringWithRange:NSMakeRange(i, 1)];
        if (![NSString emptyOrNull:s] && [s isNumString]) {
            [resultStr appendString:s];
        }
    }
    return resultStr;
}


+ (NSString *)getNumberFormatterDecimalStyle:(NSString *)number currency:(NSString *)currency{
    NSString *result = @"";
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSLocale *usLocale = nil;
    if ([currency isEqualToString:@"USD"]) {
        usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }else if ([currency isEqualToString:@"RMB"]){
        usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }else {
        usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }
    
    [numberFormatter setLocale:usLocale];
    
    NSString *currencyStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[number doubleValue]]];
    result = currencyStr;
    return result;
}

- (BOOL)isValudPWD{
    BOOL result = NO;
    if (self.length < 6 || [self isEnString] || [self isNumString]) {
        result = NO;
    }else{
        result = YES;
    }
    return result;
}

@end
