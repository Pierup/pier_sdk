//
//  DemoHttpExecutor.m
//  PierPayDemo
//
//  Created by zyma on 3/4/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PIRHttpExecutor.h"
#import <UIKit/UIKit.h>

//NSString * const PIRMERCHANTHOST = @"http://192.168.1.254:8080";
//NSString * const PIRMERCHANTHOST = @"http://pierup.ddns.net:8686";
NSString * const PIRMERCHANTHOST = @"http://piermerchant.elasticbeanstalk.com";


@interface PIRHttpExecutor ()
@property(nonatomic, assign) BOOL isFinished;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) NSURLConnection* connection;
@property(nonatomic, strong) NSMutableData* responseData;

@property(nonatomic, copy) httpCallBack success;
@property(nonatomic, copy) httpErrorBack failure;

@property(nonatomic, copy) NSString *method;

@property(nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

static PIRHttpExecutor *__connect;

@implementation PIRHttpExecutor

+ (PIRHttpExecutor *)getInstance
{
    if (!__connect) {
        @synchronized(self){
            if (!__connect) {
                __connect = [[PIRHttpExecutor alloc] init];
                __connect.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [__connect.loadingView setHidesWhenStopped:YES];
                [__connect.loadingView setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2, 0, 0)];
            }
        }
    }
    return __connect;
}

- (void)sendMessage:(void(^)(id respond))success
     andRequestJson:(NSDictionary *)requestJson
         andFailure:(void(^)(id error, int errorCode))failure
            andPath:(NSString *)path
             method:(NSString *)method{
    self.method = method;
    self.success = success;
    self.failure = failure;
    NSString *urlStr = [PIRMERCHANTHOST stringByAppendingString:path];
    if ([self.method isEqual:@"get"]){
        urlStr = [self encodeURL:requestJson urlstr:urlStr];
    }
    self.url = [NSURL URLWithString:urlStr];
    self.isFinished = NO;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:__connect.loadingView];
    [__connect.loadingView startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self start:requestJson];
    });
}

#pragma mark - --------------------NSURLConnection Delegate--------------------
- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response
{
    if (![response respondsToSelector:@selector(statusCode)] || [((NSHTTPURLResponse *)response) statusCode] < 400)
    {
        NSUInteger expectedSize = response.expectedContentLength > 0 ? (NSUInteger)response.expectedContentLength : 0;
        self.responseData = [[NSMutableData alloc] initWithCapacity:expectedSize];
    }
    else
    {
        [aConnection cancel];
        self.connection = nil;
        self.responseData = nil;
    }
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [__connect.loadingView stopAnimating];
        [__connect.loadingView removeFromSuperview];
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies]) {
            NSLog(@"%@", cookie);
        }
        
        NSString *responseJson = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [self dictionaryWithJsonData:self.responseData];
        NSLog(@"result:%@",responseJson);
        
        NSNumber *result = [resultDic objectForKey:@"code"];
        if ([result integerValue] == 200) {
            self.success(resultDic);
        }else{
            self.failure([resultDic objectForKey:@"msg"],10000);
        }
        
        self.connection = nil;
        self.isFinished = YES;
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [__connect.loadingView stopAnimating];
    [__connect.loadingView removeFromSuperview];
    self.connection = nil;
    self.responseData = nil;
    self.isFinished = YES;
    NSLog(@"http error!");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

#pragma mark - --------------------功能函数--------------------

- (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData
{
    __autoreleasing NSError * error;
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return dictionary;
}

-(void)start:(NSDictionary *)requestJson{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:self.url
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:30];
    
    
    if ([self.method isEqual:@"post"]) {
        [request setHTTPMethod: @"post"];
        NSData *requestData = [self encodeDictionary:requestJson];
        NSString *requestStr = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
        [request setHTTPBody:requestData];
        NSLog(@"resuest：%@",requestStr);
    }else if ([self.method isEqual:@"get"]){
        [request setHTTPMethod: @"get"];
    }
    self.connection = [[NSURLConnection alloc] initWithRequest:request
                                                      delegate:self
                                              startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.connection start];
    
    
    while(!self.isFinished){
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary)
    {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeURL:(NSDictionary*)dictionary urlstr:(NSString *)urlstr{
    NSMutableString *result = [[NSMutableString alloc] initWithString:urlstr];
    NSArray *allKey = [dictionary allKeys];
    if ([allKey count]>0) {
        [result appendFormat:@"?"];
    }
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [result appendFormat:@"%@=%@&",encodedKey,encodedValue];
    }
    if ([allKey count]>0) {
        return [result substringWithRange:NSMakeRange(0, result.length-1)];
    }
    return result;
}

@end
