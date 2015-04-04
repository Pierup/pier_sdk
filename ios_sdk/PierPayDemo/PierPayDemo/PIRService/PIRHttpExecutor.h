//
//  DemoHttpExecutor.h
//  PierPayDemo
//
//  Created by zyma on 3/4/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIRHttpExecutor : NSObject

typedef void(^httpCallBack)(id respondJson);
typedef void(^httpErrorBack)(id error, int errorCode);

+ (PIRHttpExecutor *)getInstance;

- (void)sendMessage:(void(^)(id respond))success
     andRequestJson:(NSDictionary *)requestJson
         andFailure:(void(^)(id error, int errorCode))failure
            andPath:(NSString *)path
             method:(NSString *)method;

@end
