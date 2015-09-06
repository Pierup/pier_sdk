//
//  PierService.m
//  PierPaySDK
//
//  Created by zyma on 1/13/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierService.h"
#import "PierHttpClient.h"
#import "PierJSONModel.h"
#import "PierConfig.h"
#import "PierTools.h"
#import "NSString+PierCheck.h"
#import "PierDataSource.h"
#import "PierLoadingView.h"
#import "PierConfig.h"
#import "PierDebugView.h"

#define HTTP_METHOD_POST        0   //@"post"
#define HTTP_METHOD_POST_JSON   1   //@"post-json"
#define HTTP_METHOD_PUT         2   //@"put"
#define HTTP_METHOD_GET         3   //@"get"

#define HTTP_HOST               @"host"
#define HTTP_PATH               @"path"
#define HTTP_METHOD             @"method"
#define RESULT_MODEL            @"resultModel"

#define SESSION_EXPIRE              1001

/** V2 */
NSString * const PIER_API_SAVE_ORDER_INFO = @"/user_api_cn/v1/user/save_order_info";

@implementation PierService

+ (void)setRequestHeader:(NSDictionary *)param requestModel:(PierPayModel *)requestModel{    
    [param setValue:[__pierDataSource.merchantParam objectForKey:DATASOURCES_COUNTRY_CODE] forKey:@"country_code"];
    [param setValue:__pierDataSource.session_token forKey:@"session_token"];
    [param setValue:__pierDataSource.user_id forKey:@"user_id"];
}

+ (void)serverSend:(ePIER_API_Type)apiType
           resuest:(PierPayModel *)requestModel
      successBlock:(PierPaySuccessBlock)success
       faliedBlock:(PierPayFailedBlock)failed
         attribute:(NSDictionary *)attribute{
    BOOL showLoad = ([[attribute objectForKey:@"show_loading"] integerValue] == 1) ? NO:YES;
    if (showLoad) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *alertMessage = [attribute objectForKey:@"show_message"];
            if (alertMessage != nil && alertMessage.length>0) {
                [PierLoadingView showLoadingView:alertMessage];
            }else{
                [PierLoadingView showLoadingView:@"Loading..."];
            }
        });
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *param = [PierJSONModel getDictionaryByObject:requestModel];
        [PierService setRequestHeader:param requestModel:requestModel];
        NSDictionary *pathAndMethod = [PierService getPathAndMethodByType:apiType requestModel:requestModel];
        ePIRHttpClientType hostType = [[pathAndMethod objectForKey:HTTP_HOST] intValue];
        NSString *path              = [pathAndMethod objectForKey:HTTP_PATH];
        NSInteger method            = [[pathAndMethod objectForKey:HTTP_METHOD] integerValue];
        switch (method) {
            case HTTP_METHOD_POST:
            {
                [[PierHttpClient sharedInstanceWithClientType:hostType] POST:path parameters:param progress:^(float progress){
                    DLog(@"progress:%f",progress);
                } success:^(id response, NSHTTPURLResponse *urlResponse) {
                    [PierService executeSuccess:response param:pathAndMethod urlResponse:urlResponse successBlock:success faliedBlock:failed attribute:attribute];
                } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                    [PierService executeFailed:pathAndMethod urlResponse:urlResponse error:error faliedBlock:failed attribute:attribute];
                }];
                break;
            }
            case HTTP_METHOD_POST_JSON:
            {
                [[PierHttpClient sharedInstanceWithClientType:hostType] JSONPOST:path parameters:param progress:^(float progress){
                    DLog(@"progress:%f",progress);
                } success:^(id response, NSHTTPURLResponse *urlResponse) {
                    [PierService executeSuccess:response param:pathAndMethod urlResponse:urlResponse successBlock:success faliedBlock:failed attribute:attribute];
                } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                    [PierService executeFailed:pathAndMethod urlResponse:urlResponse error:error faliedBlock:failed attribute:attribute];
                }];
                break;
            }
            case HTTP_METHOD_PUT:
            {
                [[PierHttpClient sharedInstanceWithClientType:hostType] JSONPUT:path parameters:param progress:^(float progress){
                    DLog(@"progress:%f",progress);
                } success:^(id response, NSHTTPURLResponse *urlResponse) {
                    [PierService executeSuccess:response param:pathAndMethod urlResponse:urlResponse successBlock:success faliedBlock:failed attribute:attribute];
                } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                    [PierService executeFailed:pathAndMethod urlResponse:urlResponse error:error faliedBlock:failed attribute:attribute];
                }];
                break;
            }
            case HTTP_METHOD_GET:
            {
                [[PierHttpClient sharedInstanceWithClientType:hostType] GET:path saveToPath:nil parameters:nil progress:^(float progress) {
                    
                } success:^(id response, NSHTTPURLResponse *urlResponse) {
                    [PierService executeSuccess:response param:pathAndMethod urlResponse:urlResponse successBlock:success faliedBlock:failed attribute:attribute];
                } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                    [PierService executeFailed:pathAndMethod urlResponse:urlResponse error:error faliedBlock:failed attribute:attribute];
                }];
                break;
            }
            default:
                break;
        }
    });
}

+ (void)executeSuccess:(id)result
                 param:(NSDictionary *)param
           urlResponse:(NSHTTPURLResponse *)urlResponse
          successBlock:(PierPaySuccessBlock)success
           faliedBlock:(PierPayFailedBlock)failed
             attribute:(NSDictionary *)attribute{
    BOOL showLoad = ([[attribute objectForKey:@"show_loading"] integerValue] == 1) ? NO:YES;
    if (showLoad) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [PierLoadingView hindLoadingView];
        });
    }
    
    DLog(@"%@Response",result);
    Class resultClass = NSClassFromString([param objectForKey:RESULT_MODEL]);

    NSDictionary *resultDic = nil;
    if (result[@"result"] != nil) {
        resultDic = result[@"result"];
    }else{
        resultDic = result;
    }
    
    if (resultDic!=nil) {
        
#ifdef DEBUG_ENV
        [[PierDebugView shareInstance] appendLog:resultDic.description];
#endif
        if ([resultDic respondsToSelector:@selector(objectForKey:)]) {
            __pierDataSource.session_token = [resultDic valueForKey:@"session_token"];
            __pierDataSource.user_id       = [resultDic valueForKey:@"user_id"];
        }else{
            DLog(@"Result nil.");
        }
        PierPayModel *resultModel   = [PierJSONModel getObjectByDictionary:resultDic clazz:resultClass];
        [resultModel setValue:[NSString getUnNilString:result[@"code"]] forKey:@"code"];
        [resultModel setValue:[NSString getUnNilString:result[@"message"]] forKey:@"message"];
        
        NSInteger code = [resultModel.code integerValue];
        if (code == 200) {
            success(resultModel);
        }else{
            NSError *error = nil;
            if (resultModel) {
                error = [NSError errorWithDomain:resultModel.message code:[resultModel.code integerValue] userInfo:nil];
                DLog(@"[errov]:%@",error);
            }
            
            switch (code) {
                case SESSION_EXPIRE://sesson 过期
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            failed(error);
        }
    }else{
        DLog(@"Result nil.");
    }
}


+ (void)executeFailed:(NSDictionary *)param
          urlResponse:(NSHTTPURLResponse *)urlResponse
                error:(NSError *)error
          faliedBlock:(PierPayFailedBlock)failed
            attribute:(NSDictionary *)attribute{
    BOOL showLoad = ([[attribute objectForKey:@"show_loading"] integerValue] == 1) ? NO:YES;
    BOOL showAlert = ([[attribute objectForKey:@"show_alert"] integerValue] == 1) ? NO:YES;
    if (showLoad) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [PierLoadingView hindLoadingView];
        });
    }
    
    DLog(@"%@urlResponse",urlResponse);
    if (showAlert) {
//        NSDictionary *alertParam = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    @"icon_error",@"title_image_name",
//                                    @"error",@"title",
//                                    [error domain],@"message",nil];
//        [PierAlertView showPierAlertView:self param:alertParam type:ePierAlertViewType_error approve:^(NSString *userInput) {
//            return YES;
//        }];
    }
    failed(error);
}

+ (NSDictionary *)getPathAndMethodByType:(ePIER_API_Type)apiType requestModel:(PierPayModel *)requestModel{
    NSDictionary *result = nil;
    switch (apiType) {
        case ePIER_API_SAVE_ORDER_INFO:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_SAVE_ORDER_INFO,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierRequestSaveOrderInfoResponse",RESULT_MODEL,nil];
            break;
        default:
            break;
    }
    return result;
}

@end
