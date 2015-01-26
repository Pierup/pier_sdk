//
//  PIRService.m
//  PierPaySDK
//
//  Created by zyma on 1/13/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PIRService.h"
#import "PIRSDKPath.h"
#import "PIRHttpClient.h"
#import "PIRJSONModel.h"
#import "PIRConfig.h"

#define HTTP_METHOD_POST        0   //@"post"
#define HTTP_METHOD_POST_JSON   1   //@"post-json"
#define HTTP_METHOD_PUT         2   //@"put"
#define HTTP_METHOD_GET         3   //@"get"

#define HTTP_PATH               @"path"
#define HTTP_METHOD             @"method"
#define RESULT_MODEL            @"resultModel"

static NSString *__session_token = @"";
static NSString *__user_id = @"";


@implementation PIRService

+ (void)serverSend:(ePIER_API_Type)apiType
           resuest:(PIRPayModel *)requestModel
      successBlock:(PierPaySuccessBlock)success
       faliedBlock:(PierPayFailedBlock)failed{
    NSDictionary *param = [PIRJSONModel getDictionaryByObject:requestModel];
    [param setValue:__user_id forKey:@"user_id"];
    [param setValue:__session_token forKey:@"session_token"];
    
    NSDictionary *pathAndMethod = [PIRService getPathAndMethodByType:apiType];
    NSString *path              = [pathAndMethod objectForKey:HTTP_PATH];
    NSInteger method            = [[pathAndMethod objectForKey:HTTP_METHOD] integerValue];
    switch (method) {
        case HTTP_METHOD_POST:
        {
            [[PIRHttpClient sharedInstanceWithClientType:ePIRHttpClientType_User_V2] POST:path parameters:param progress:^(float progress){
                DLog(@"progress:%f",progress);
            } success:^(id response, NSHTTPURLResponse *urlResponse) {
                [PIRService executeSuccess:response param:pathAndMethod urlResponse:urlResponse successBlock:success faliedBlock:failed];
            } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                [PIRService executeFailed:pathAndMethod urlResponse:urlResponse error:error faliedBlock:failed];
            }];
            break;
        }
        case HTTP_METHOD_POST_JSON:
        {
            [[PIRHttpClient sharedInstanceWithClientType:ePIRHttpClientType_User_V2] JSONPOST:path parameters:param progress:^(float progress){
                DLog(@"progress:%f",progress);
            } success:^(id response, NSHTTPURLResponse *urlResponse) {
                [PIRService executeSuccess:response param:pathAndMethod urlResponse:urlResponse successBlock:success faliedBlock:failed];
            } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                [PIRService executeFailed:pathAndMethod urlResponse:urlResponse error:error faliedBlock:failed];
            }];
            break;
        }
        case HTTP_METHOD_PUT:
        {
            [[PIRHttpClient sharedInstanceWithClientType:ePIRHttpClientType_User_V2] JSONPUT:path parameters:param progress:^(float progress){
                DLog(@"progress:%f",progress);
            } success:^(id response, NSHTTPURLResponse *urlResponse) {
                [PIRService executeSuccess:response param:pathAndMethod urlResponse:urlResponse successBlock:success faliedBlock:failed];
            } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                [PIRService executeFailed:pathAndMethod urlResponse:urlResponse error:error faliedBlock:failed];
            }];
            break;
        }
        case HTTP_METHOD_GET:
        {
            [[PIRHttpClient sharedInstanceWithClientType:ePIRHttpClientType_User_V2] GET:path saveToPath:nil parameters:nil progress:^(float progress) {
                
            } success:^(id response, NSHTTPURLResponse *urlResponse) {
                [PIRService executeSuccess:response param:pathAndMethod urlResponse:urlResponse successBlock:success faliedBlock:failed];
            } failed:^(NSHTTPURLResponse *urlResponse, NSError *error) {
                [PIRService executeFailed:pathAndMethod urlResponse:urlResponse error:error faliedBlock:failed];
            }];
            break;
        }
        default:
            break;
    }
}

+ (void)executeSuccess:(id)result
                 param:(NSDictionary *)param
           urlResponse:(NSHTTPURLResponse *)urlResponse
          successBlock:(PierPaySuccessBlock)success
           faliedBlock:(PierPayFailedBlock)failed{
    DLog(@"%@Response",result);
    Class resultClass          = NSClassFromString([param objectForKey:RESULT_MODEL]);
    NSDictionary *resultDic = result[@"result"];
    if (resultDic) {
        PIRPayModel *resultModel   = [PIRJSONModel getObjectByDictionary:resultDic clazz:resultClass];
        [resultModel setValue:result[@"code"] forKey:@"code"];
        [resultModel setValue:result[@"message"] forKey:@"message"];
        __session_token = [resultDic valueForKey:@"session_token"];
        __user_id       = [resultDic valueForKey:@"user_id"];
        if ([resultModel.code integerValue] == 200) {
            success(resultModel);
        }else{
            NSError *error = nil;
            if (resultModel) {
                error = [NSError errorWithDomain:resultModel.message code:[resultModel.code integerValue] userInfo:nil];
                DLog(@"[errov]:%@",error);
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
           faliedBlock:(PierPayFailedBlock)failed{
    DLog(@"%@urlResponse",urlResponse);
    failed(error);
}

+ (NSDictionary *)getPathAndMethodByType:(ePIER_API_Type)apiType{
    NSDictionary *result = nil;
    switch (apiType) {
        case ePIER_API_TRANSACTION_SMS:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      PIER_API_TRANSACTION_SMS,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"TransactionSMSResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_AUTH_TOKEN_V2:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      PIER_API_GET_AUTH_TOKEN_V2,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"GetAuthTokenV2Response",RESULT_MODEL,nil];
            break;
        default:
            break;
    }
    return result;
}
@end
