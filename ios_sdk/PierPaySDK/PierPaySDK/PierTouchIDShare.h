//
//  PIRTouchIDController.h
//  Pier
//
//  Created by zyma on 11/17/14.
//  Copyright (c) 2014 PIER. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^TouchIDSuccessBlock) (void);
typedef void (^TouchIDFailedBlock)  (void);
typedef void (^TouchIDCalcelBlock)  (void);
typedef void (^TouchIDEnterPasswordBlock)  (void);
@interface PierTouchIDShare : NSObject

+ (instancetype)sharedInstance;
/**
 *  @param: verfy:是否检验本地 NO：不检验本地。
 */
- (BOOL)hasTouchIDAuthority;
+ (void)startTouch:(TouchIDSuccessBlock)success
            cancel:(TouchIDCalcelBlock)cancel
            failed:(TouchIDFailedBlock)failed
     enterPassword:(TouchIDEnterPasswordBlock)enterPassword;

@end
