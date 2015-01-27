//
//  PierTools.m
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierTools.h"

@implementation PierTools

NSBundle *pierBoundle(){
    if(!__pierBoundle){
        __pierBoundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"PierResource" withExtension:@"bundle"]];
    }
    return __pierBoundle;
}

@end
