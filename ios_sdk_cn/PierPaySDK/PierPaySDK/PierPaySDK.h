//
//  PierPaySDK.h
//  PierPaySDK
//
//  Created by zyma on 8/31/15.
//  Copyright (c) 2015 pier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^payWithPierComplete)(NSDictionary *result, NSError *error);

@interface PierPaySDK : NSObject

- (void)createPayment:(NSDictionary *)charge
             delegate:(id)delegate
           completion:(payWithPierComplete)completion;

@end
