//
//  PierJsonModel.m
//  PierJsonModel
//
//  Created by zyma on 10/30/14.
//  Copyright (c) 2014 zyma. All rights reserved.
//

#import "PierJSONModel.h"
#import <objc/runtime.h>
#import "PierConfig.h"

/**  **************序列化解析器************** */
/** 序列化对象 */
id serializeObject(id obj, NSString *clazz);
/** 反序列化对象 */
id deserializeObject(id dic, NSString *clazz);
/** 序列化数组对象 */
NSArray * serializeArray(id obj, NSString *clazz);
/** 反序列化数组对象 */
NSArray * deserializeArray(id obj, NSString *clazz);
/** 序列化字典对象 */
NSDictionary * serializeDictionary(id obj, NSString *clazz);
/** 反序列化字典对象 */
NSDictionary * deserializeDictionary(id obj, NSString *clazz);
/** 序列化集合对象 */
NSSet * serializeSet(id obj, NSString *clazz);
/** 反序列化集合对象 */
NSSet * deserializeSet(id obj, NSString *clazz);

/** **************类型判断工具************** */
/** 获取类型符号 */
NSString *getPropertyTypeWithDescription(NSString *description);
/** 获取容器的泛型类型 */
NSString *getGenericType(NSString *propertyType);
/** 判断字CLass类型是否是JsonModel*/
BOOL stringTypeIsJsonModel(Class clazz);
/** 判断字符串类型是否是NSArray */
BOOL stringTypeIsArray(NSString *type);
/** 判断对象是否是NSArray类型 */
BOOL objectTypeIsArray(id obj);
/** 判断字符串是否是NSDictionary类型 */
BOOL stringTypeIsDictionary(NSString *type);
/** 判断对象是否是NSDictionary类型 */
BOOL objectTypeIsDictionary(id obj);
/** 判断字符串是否是NSSset类型 */
BOOL stringTypeIsSet(NSString *type);
/** 判断对象是否是NSSset类型 */
BOOL objectTypeIsSet(id obj);

/** **************classinfo tools************** */
static NSMutableDictionary *__classDeclatedCacheMap;

@interface ModelDeclated : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pramDescription;
@end
@implementation ModelDeclated @end

/**获取第一层model，的第一个字段作为主键*/
NSString *getPrimaryKey(Class clazz);
/** 获取model的属性，包括父类的 */
NSArray *getPropertyDeclared(Class clazz);

@implementation PierJSONModel

static NSArray *enumIntFlagArray = NULL;

+ (id)getObjectByDictionary:(NSDictionary *)dic clazz:(Class)clazz{
    id result = nil;
    if (stringTypeIsJsonModel(clazz)) {
        result = deserializeObject(dic, NSStringFromClass(clazz));
    }
    return result;
}


+ (NSDictionary *)getDictionaryByObject:(id)object{
    Class clazz = [object class];
    id result = nil;
    if (stringTypeIsJsonModel(clazz)) {
        result = serializeObject(object, NSStringFromClass(clazz));
    }
    return result;
}

#pragma mark - --------------------classinfo tools--------------------
#pragma mark 获取第一层model，的第一个字段作为主键
NSString *getPrimaryKey(Class clazz){
    NSString *clazz_s = NSStringFromClass(clazz);
    NSArray *classDeclates = [__classDeclatedCacheMap objectForKey:clazz_s];
    NSString *result = @"";
    if (classDeclates && [classDeclates count]>0) {
        ModelDeclated *declatedModel = [classDeclates objectAtIndex:0];
        result = declatedModel.name;
    }
    return result;
}
#pragma mark 获取model的属性，包括父类的
NSArray *getPropertyDeclared(Class clazz){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __classDeclatedCacheMap = [[NSMutableDictionary alloc] init];
    });
    NSMutableArray *resultArray = nil;
    NSString *clazz_s = NSStringFromClass(clazz);
    NSArray *cache = [__classDeclatedCacheMap objectForKey:clazz_s];
    if (cache && [cache count]>0) {
        resultArray = [NSMutableArray arrayWithArray:cache];
    }else{
        resultArray = [[NSMutableArray alloc] init];
        while (stringTypeIsJsonModel(clazz)){
            unsigned int numberOfProperties = 0;
            objc_property_t *properties = class_copyPropertyList(clazz, &numberOfProperties);
            for (int i = 0; i < numberOfProperties; i++) {
                objc_property_t property = properties[i];
                const char *name_c = property_getName(property);
                const char *description_c = property_getAttributes(property);
                NSString *name_s = [NSString stringWithUTF8String:name_c];
                NSString *description_s = [NSString stringWithUTF8String:description_c];
                ModelDeclated *declatedModel = [[ModelDeclated alloc] init];
                declatedModel.name = name_s;
                declatedModel.pramDescription = description_s;
                [resultArray addObject:declatedModel];
            }
            clazz = class_getSuperclass(clazz);
            free(properties);
        }
    }
    if ([__classDeclatedCacheMap objectForKey:clazz_s] == nil) {
        [__classDeclatedCacheMap setValue:resultArray forKey:clazz_s];
    }
    return resultArray;
}

#pragma mark - --------------------serialize--------------------
#pragma mark 序列化对象
id  serializeObject(id obj, NSString *clazz){
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    Class cla = NSClassFromString(clazz);
    if (stringTypeIsJsonModel(cla)) {
        NSArray *propertyDeclareds = getPropertyDeclared(cla);
        for (ModelDeclated *declatedModel in propertyDeclareds) {
            NSString *name_s = declatedModel.name;
            NSString *description_s = declatedModel.pramDescription;
            id object = [obj valueForKey:name_s];
//            DLog(@"propertytype = %@\nname= %@ \nvalue = %@",description_s,name_s,object);
            if (object == NULL || name_s == NULL || description_s == NULL) {
                continue;
            }
            NSString *propertyType = getPropertyTypeWithDescription(description_s);
            id serializeObj = nil;
            if (stringTypeIsJsonModel(NSClassFromString(propertyType))) {
                serializeObj = serializeObject(object, propertyType);
            }else if ([description_s hasPrefix:@"T@\""]) {
                if (stringTypeIsArray(propertyType)) {//序列化Array
                    serializeObj = serializeArray(object, propertyType);
                }else if (stringTypeIsDictionary(propertyType)){//序列化Dictionary
                    serializeObj = serializeDictionary(object, propertyType);
                }else if (stringTypeIsSet(propertyType)){//序列化set
                    serializeObj = serializeSet(object, propertyType);
                }else{
                    serializeObj = object;
                }
            }else{
                //支持KVC 的类型 v--void //*--char* //#--class //:--SEL//[] NOT supported
                if (enumIntFlagArray == NULL) {
                    enumIntFlagArray = @[@"c",@"C",@"i",@"I",@"s",@"S",@"l",@"L",@"q",@"Q",@"f",@"d",@"B"];
                }
                if ([enumIntFlagArray containsObject:propertyType]) {
                    serializeObj = object;
                }else{
                    DLog(@"warning 不支持的基础类型:obj=%@,clazz=%@,description=%@",object,name_s,description_s);
                    continue;
                }
                
            }
            [result setValue:serializeObj forKey:name_s];
        }
    }else if (stringTypeIsArray(clazz)) {//解析Array
        return serializeArray(obj, clazz);
    }else if (stringTypeIsDictionary(clazz)){//解析Dictionary
        return serializeDictionary(obj, clazz);
    }else if (stringTypeIsSet(clazz)){//解析set
        return serializeSet(obj, clazz);
    }else{
        DLog(@"warning 不支持的基础类型:obj=%@,clazz=%@",obj,clazz);
    }
    return result;
}
#pragma mark 反序列化对象
id deserializeObject(id dic, NSString *clazz){
    Class cla = NSClassFromString(clazz);
    id result = [cla new];
    if (stringTypeIsJsonModel(cla)) {
        NSArray *propertyDeclareds = getPropertyDeclared(cla);
        for (ModelDeclated *declatedModel in propertyDeclareds) {
            NSString *name_s = declatedModel.name;
            NSString *description_s = declatedModel.pramDescription;
            id obj = nil;
            if ([dic respondsToSelector:@selector(objectForKey:)]) {
                obj = [dic objectForKey:name_s];
            }else{//如果不支持KVC说明 是一个Array、dic、set等容器类的对象，直接赋给obj
                if ([getPrimaryKey(cla) isEqualToString:name_s]){
                    obj = dic;
                }else{
                    DLog(@"error model 命名和服务接口不一致dic=%@,name_s=%@",dic,name_s);
//                    assert(0);
//                    assert([name_s isEqualToString:@"assert"]);
//                    assert([name_s isEqualToString:@"status_code"]);
//                    assert([name_s isEqualToString:@"status_message"]);
                    continue;
                }
            }
            
            if (obj == nil || (NSNull *)obj == [NSNull null] || name_s == nil || description_s == nil) {
//                DLog(@"warning model字段为空 = %@\nname= %@ \nvalue = %@",description_s,name_s,obj);
                continue;
            }
            id serializeObj = nil;
            NSString *propertyType = getPropertyTypeWithDescription(description_s);
            /** object */
            if (stringTypeIsJsonModel(NSClassFromString(propertyType))) {
                serializeObj = deserializeObject(dic,propertyType);
            }else if ([description_s hasPrefix:@"T@\""]) {
                if (stringTypeIsArray(propertyType)) {//解析Array
                    NSArray *array = deserializeArray(obj, propertyType);
                    serializeObj = array;
                }else if (stringTypeIsDictionary(propertyType)){//解析Dictionary
                    NSDictionary *dic = deserializeDictionary(obj, propertyType);
                    serializeObj = dic;
                }else if (stringTypeIsSet(propertyType)){//解析set
                    NSSet *set = deserializeSet(obj, propertyType);
                    serializeObj = set;
                }else{
                    serializeObj = obj;
                }
            }else{
                //支持KVC 的类型 v--void //*--char* //#--class //:--SEL//[] NOT supported
                if (enumIntFlagArray == NULL) {
                    enumIntFlagArray = @[@"c",@"C",@"i",@"I",@"s",@"S",@"l",@"L",@"q",@"Q",@"f",@"d",@"B"];
                }
                if ([enumIntFlagArray containsObject:propertyType]) {
                    serializeObj = obj;
                }else{
                    DLog(@"warning 不支持的基础类型:dic=%@,clazz=%@,description=%@",obj,name_s,description_s);
                    continue;
                }
            }
            [result setValue:serializeObj forKey:name_s];
        }
    }else if (stringTypeIsArray(clazz)) {//解析Array
        return deserializeArray(dic, clazz);
    }else if (stringTypeIsDictionary(clazz)){//解析Dictionary
        return deserializeDictionary(dic, clazz);
    }else if (stringTypeIsSet(clazz)){//解析set
        return deserializeSet(dic, clazz);
    }else{
        DLog(@"warning 不支持的基础类型:dic=%@,clazz=%@",dic,clazz);
    }
    return result;
}

#pragma mark 序列化数组对象
NSArray * serializeArray(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = getGenericType(clazz);
    NSArray *array = [NSArray arrayWithArray:obj];
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
    if (genericType.length>0) {
        for (int i = 0; i < [array count]; i++) {
            id item = [array objectAtIndex:i];
            NSDictionary *dic = serializeObject(item, genericType);
            [resultArray addObject:dic];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultArray;
}

#pragma mark 反序列化数组对象
NSArray * deserializeArray(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = getGenericType(clazz);
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:[obj count]];
    if (genericType.length>0) {
        for (int i = 0; i < [obj count]; i++) {
            id item = [obj objectAtIndex:i];
            id model = deserializeObject(item, genericType);
            [resultArray addObject:model];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultArray;
}

#pragma mark 序列化字典对象
NSDictionary * serializeDictionary(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = getGenericType(clazz);
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    if (genericType.length>0) {
        NSArray *keys = [obj allKeys];
        for (NSString * key in keys) {
            id item = [obj objectForKey:key];
            id model = serializeObject(item, genericType);
            [resultDic setObject:model forKey:key];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultDic;
}

#pragma mark 反序列化字典对象
NSDictionary *  deserializeDictionary(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = getGenericType(clazz);
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    if (genericType.length>0) {
        NSArray *keys = [obj allKeys];
        for (NSString * key in keys) {
            id item = [obj objectForKey:key];
            id model = deserializeObject(item, genericType);
            [resultDic setObject:model forKey:key];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultDic;
}

#pragma mark 序列化集合对象
NSSet * serializeSet(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = getGenericType(clazz);
    NSMutableSet *resultSet = [NSMutableSet set];
    if (genericType.length>0) {
        NSEnumerator *enumerator = [obj objectEnumerator];
        for (id item in enumerator) {
            id model = serializeObject(item, genericType);
            [resultSet addObject:model];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultSet;
}

#pragma mark 反序列化集合对象
NSSet * deserializeSet(id obj, NSString *clazz){
    /** 是否有泛型 */
    NSString *genericType = getGenericType(clazz);
    NSMutableSet *resultSet = [NSMutableSet set];
    if (genericType.length>0) {
        NSEnumerator *enumerator = [obj objectEnumerator];
        for (id item in enumerator) {
            id model = deserializeObject(item, genericType);
            [resultSet addObject:model];
        }
    }else{
        DLog(@"warning model没有设置泛型:obj=%@,propertyType=%@",obj,clazz);
        return obj;
    }
    return resultSet;
}

#pragma mark - --------------------tools--------------------
#pragma mark - 获取类型符号
NSString *getPropertyTypeWithDescription(NSString *description)
{
    NSString *resultTypeString = nil;
    
    if (description.length > 0) {
        NSUInteger endIndex = [description rangeOfString:@","].location;
        if (endIndex != NSNotFound)
        {
            resultTypeString = [description substringWithRange:NSMakeRange(1, endIndex-1)];
            resultTypeString = [resultTypeString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            resultTypeString = [resultTypeString stringByReplacingOccurrencesOfString:@"@" withString:@""];
        }
    }
    
    return resultTypeString;
}


#pragma mark - 判断类型
#pragma mark 获取容器的泛型类型
NSString *getGenericType(NSString *propertyType){
    NSString *genericType = @"";
    if ([propertyType rangeOfString:@"<"].location != NSNotFound) {
        NSUInteger startIndex = [propertyType rangeOfString:@"<"].location;
        NSUInteger endIndex = [propertyType rangeOfString:@">"].location;
        genericType = [propertyType substringWithRange:NSMakeRange(startIndex+1, endIndex-startIndex-1)];
    }
    return genericType;
}

#pragma mark 判断Class类型是否是JsonModel
BOOL stringTypeIsJsonModel(Class clazz)
{
    if ([clazz isSubclassOfClass:NSClassFromString(@"PierJSONModel")]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 判断字符串类型是否是NSArray
BOOL stringTypeIsArray(NSString *type)
{
    if ([type rangeOfString:@"<"].location == NSNotFound) {
        if ([type rangeOfString:@"NSArray"].location != NSNotFound ||
            [type rangeOfString:@"NSMutableArray"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }else{
        NSUInteger endIndex = [type rangeOfString:@"<"].location;
        NSString *propertyType = [type substringWithRange:NSMakeRange(0, endIndex)];
        if ([propertyType rangeOfString:@"NSArray"].location != NSNotFound ||
            [propertyType rangeOfString:@"NSMutableArray"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }
}

#pragma mark 判断对象是否是NSArray类型
BOOL objectTypeIsArray(id obj)
{
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 判断字符串是否是NSDictionary类型
BOOL stringTypeIsDictionary(NSString *type)
{
    if ([type rangeOfString:@"<"].location == NSNotFound){
        if ([type rangeOfString:@"NSDictionary"].location != NSNotFound ||
            [type rangeOfString:@"NSMutableDictionary"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }else{
        NSUInteger endIndex = [type rangeOfString:@"<"].location;
        NSString *propertyType = [type substringWithRange:NSMakeRange(0, endIndex)];
        if ([propertyType rangeOfString:@"NSDictionary"].location != NSNotFound ||
            [propertyType rangeOfString:@"NSMutableDictionary"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }
}
#pragma mark 判断对象是否是NSDictionary类型
BOOL objectTypeIsDictionary(id obj)
{
    if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 判断字符串是否是NSSset类型
BOOL stringTypeIsSet(NSString *type)
{
    if ([type rangeOfString:@"<"].location == NSNotFound){
        if ([type rangeOfString:@"NSSet"].location != NSNotFound || [type rangeOfString:@"NSMutableSet"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }else{
        NSUInteger endIndex = [type rangeOfString:@"<"].location;
        NSString *propertyType = [type substringWithRange:NSMakeRange(0, endIndex)];
        if ([propertyType rangeOfString:@"NSSet"].location != NSNotFound ||
            [propertyType rangeOfString:@"NSMutableSet"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }
}
#pragma mark 判断对象是否是NSSset类型
BOOL objectTypeIsSet(id obj)
{
    if ([obj isKindOfClass:[NSSet class]] || [obj isKindOfClass:[NSMutableSet class]]) {
        return YES;
    }else{
        return NO;
    }
}
@end
