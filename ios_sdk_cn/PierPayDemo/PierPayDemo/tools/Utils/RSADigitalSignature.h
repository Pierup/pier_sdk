//
//  RSADigitalSignature.h
//  PierPayDemo
//
//  Created by zyma on 9/2/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSADigitalSignature : NSObject

+ (NSString *)createSignature:(NSString *)string privateKey:(NSString *)privateKey;
+ (BOOL)verify:(NSString *)string sign:(NSString *)signString publicKey:(NSString *)publicKey;

@end
