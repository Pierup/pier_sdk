//
//  PierTools.m
//  PierPaySDK
//
//  Created by zyma on 1/27/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierTools.h"
#import <UIKit/UIKit.h>

/** static properities */
static NSBundle *__pierBoundle;

@implementation PierTools

NSBundle *pierBoundle(){
    if(!__pierBoundle){
        __pierBoundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"PierResource" withExtension:@"bundle"]];
    }
    return __pierBoundle;
}

#pragma mark - Get iPhone Version
double IPHONE_OS_MAIN_VERSION() {
    static double __iphone_os_main_version = 0.0;
    if(__iphone_os_main_version == 0.0) {
        NSString *sv = [[UIDevice currentDevice] systemVersion];
        NSScanner *sc = [[NSScanner alloc] initWithString:sv];
        if(![sc scanDouble:&__iphone_os_main_version])
            __iphone_os_main_version = -1.0;
    }
    return __iphone_os_main_version;
}

#pragma mark - Get ImageName in Bundle
NSString *getImagePath(NSString *imageName){
    NSString *path = @"";
    NSBundle *bundle = pierBoundle();
    
    //    NSString *bindlePath = [[NSBundle mainBundle] pathForResource:@"PierResource" ofType:@"bundle"];
    //    NSBundle *bundle = [NSBundle bundleWithPath:bindlePath];
    path = [bundle pathForResource:imageName ofType:@"png"];
    return path;
}
@end
