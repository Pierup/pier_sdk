//
//  NSString+Check.h
//  Pier
//
//  Created by zyma on 10/30/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, eDOBFormate){
    eDOBFormate_invalid,
    eDOBFormate_available,
    eDOBFormate_less18,
    eDOBFormate_more120
};


@interface NSString (PierCheck)

/**
 * 判断字串是否是空
 */
+ (BOOL)emptyOrNull:(NSString *)str;

/**
 * 获取非nil的string
 */
+ (NSString *)getUnNilString:(NSString *)str;

/**
 *  字典判断工具
 *
 *  @param array 字典
 *
 *  @return 是否为空
 */
+ (BOOL)arrayEmptyOrNull:(NSArray *)array;

/**
 * 判断字串是否是数字
 */
- (bool)isNumString;

/**
 * 是否是英文
 */
- (bool)isEnString;

/**
 * 是否只有英文或者数字
 */
- (BOOL)isStringOnlyEnOrNum;

/**
 * 是否是中文
 */
- (bool)isValidCN;

/**
 * email是否合法
 */
- (bool)isValidEMail;

/**
 * dob法
 */

- (eDOBFormate)checkDOBFormate;

/**
 * 计算字串的长度(按字节计算，一个中文返回2)
 */
- (int)strByteLength;

/**
 * 是否包含子串
 */
- (BOOL)isContainString:(NSString *)subString;

/**
 * 电话号码格式化
 * 10位：(000)000-0000
 * 11位：000-0000-0000
 */
- (NSString *)phoneFormat;

/**
 * 电话号码去除格式化
 */
- (NSString *)phoneClearFormat;

/**
 * isValudSSN
 */
- (BOOL)isValudSSN;

/**
 * 获取字符串中的数字
 */
+ (NSString *)getNumbers:(NSString*)stirng;

/**
 * 金额字符串
 * USD：@"$"  //en_US
 * RMB：@"￥" //zh_CN
 */
+ (NSString *)getNumberFormatterDecimalStyle:(NSString *)number currency:(NSString *)currency;

/**
 * 是否是合格的密码
 */
- (BOOL)isValudPWD;

@end
