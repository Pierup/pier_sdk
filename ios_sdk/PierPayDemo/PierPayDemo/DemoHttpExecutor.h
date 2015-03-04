//
//  DemoHttpExecutor.h
//  PierPayDemo
//
//  Created by zyma on 3/4/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoHttpExecutor : NSObject

typedef void(^httpCallBack)(NSString *respondJson);
typedef void(^httpErrorBack)(NSString *error, int errorCode);

+ (DemoHttpExecutor *)getInstance;

- (void)sendMessage:(void(^)(NSString *respond))success
     andRequestJson:(NSDictionary *)requestJson
         andFailure:(void(^)(NSString *error, int errorCode))failure
            andPath:(NSString *)path
             method:(NSString *)method;

@end
