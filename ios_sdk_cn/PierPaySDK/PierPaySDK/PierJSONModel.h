//
//  PierJsonModel.h
//  PierJsonModel
//
//  Created by zyma on 10/30/14.
//  Copyright (c) 2014 zyma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PierJSONModel : NSObject

+ (id)getObjectByDictionary:(NSDictionary *)dic clazz:(Class)clazz;

+ (NSDictionary *)getDictionaryByObject:(id)object;

@end
