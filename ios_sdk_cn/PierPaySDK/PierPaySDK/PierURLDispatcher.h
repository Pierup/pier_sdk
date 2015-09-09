//
//  PierURLDispatcher.h
//  PierPaySDK
//
//  Created by zyma on 9/9/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PierWebActionModel;

typedef enum : NSUInteger {
    ePierAction_Login           = 10003,
    ePierAction_Pay             = 10002,
    ePierAction_Return          = 10001,
} ePierAction;

@protocol PierURLDispatcherDeleagte <NSObject>

- (void)dispatcheFinish:(PierWebActionModel *)model;

@end

// action model
@interface PierWebActionModel : NSObject

@property (nonatomic, assign) ePierAction action_type;
@property (nonatomic, strong) NSDictionary *result;

@end

@interface PierURLDispatcher : NSObject

@property (nonatomic, weak) id<PierURLDispatcherDeleagte> delegate;

//+ (PierURLDispatcher *)shareInstance;

//根据第三方传来的url跳转到相应页面
- (BOOL)dispatchURL:(NSURL *)url viewController:(UIViewController *)viewController;

@end
