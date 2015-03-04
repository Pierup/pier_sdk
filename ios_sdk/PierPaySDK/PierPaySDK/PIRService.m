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
#import "PierTools.h"
#import "NSString+Check.h"
#import "PIRDataSource.h"

#define HTTP_METHOD_POST        0   //@"post"
#define HTTP_METHOD_POST_JSON   1   //@"post-json"
#define HTTP_METHOD_PUT         2   //@"put"
#define HTTP_METHOD_GET         3   //@"get"

#define HTTP_HOST               @"host"
#define HTTP_PATH               @"path"
#define HTTP_METHOD             @"method"
#define RESULT_MODEL            @"resultModel"

//static NSString *__session_token = @"";
//static NSString *__user_id = @"";


@implementation PIRService

+ (void)setRequestHeader:(NSDictionary *)param requestModel:(PIRPayModel *)requestModel{
    NSString *phone = [param valueForKey:@"phone"];
    if (![NSString emptyOrNull:phone]) {
        __dataSource.phone = phone;
    }else {
        phone = __dataSource.phone;
    }
    if (![NSString emptyOrNull:phone]) {
        NSInteger phone_length = phone.length;
        if (phone_length > 0) {
            if (phone_length == 10) {
                [param setValue:@"US" forKey:@"country_code"];
            }else if (phone_length == 11){
                [param setValue:@"CN" forKey:@"country_code"];
            }else{
                [param setValue:@"US" forKey:@"country_code"];
            }
            __dataSource.country_code = [param objectForKey:@"country_code"];
        }
    }
    
    [param setValue:__dataSource.session_token forKey:@"session_token"];
    [param setValue:__dataSource.user_id forKey:@"user_id"];
}

+ (void)serverSend:(ePIER_API_Type)apiType
           resuest:(PIRPayModel *)requestModel
      successBlock:(PierPaySuccessBlock)success
       faliedBlock:(PierPayFailedBlock)failed{
    NSDictionary *param = [PIRJSONModel getDictionaryByObject:requestModel];
    [PIRService setRequestHeader:param requestModel:requestModel];
    NSDictionary *pathAndMethod = [PIRService getPathAndMethodByType:apiType requestModel:requestModel];
    ePIRHttpClientType hostType = [[pathAndMethod objectForKey:HTTP_HOST] intValue];
    NSString *path              = [pathAndMethod objectForKey:HTTP_PATH];
    NSInteger method            = [[pathAndMethod objectForKey:HTTP_METHOD] integerValue];
    switch (method) {
        case HTTP_METHOD_POST:
        {
            [[PIRHttpClient sharedInstanceWithClientType:hostType] POST:path parameters:param progress:^(float progress){
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
            [[PIRHttpClient sharedInstanceWithClientType:hostType] JSONPOST:path parameters:param progress:^(float progress){
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
            [[PIRHttpClient sharedInstanceWithClientType:hostType] JSONPUT:path parameters:param progress:^(float progress){
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
            [[PIRHttpClient sharedInstanceWithClientType:hostType] GET:path saveToPath:nil parameters:nil progress:^(float progress) {
                
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
        __dataSource.session_token = [resultDic valueForKey:@"session_token"];
        __dataSource.user_id       = [resultDic valueForKey:@"user_id"];
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

+ (NSDictionary *)getPathAndMethodByType:(ePIER_API_Type)apiType requestModel:(PIRPayModel *)requestModel{
    NSDictionary *result = nil;
    switch (apiType) {
        case ePIER_API_TRANSACTION_SMS:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_TRANSACTION_SMS,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"TransactionSMSResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_AUTH_TOKEN_V2:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_AUTH_TOKEN_V2,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"GetAuthTokenV2Response",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_ACTIVITY_CODE:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_ACTIVITY_CODE,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"GetRegisterCodeResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_ACTIVITION:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_ACTIVITION,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"RegSMSActiveResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_ACTIVITION_REGIST:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_ACTIVITION_REGIST,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"RegisterResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_UPDATEUSER:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_UPDATEUSER,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"UpdateResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_APPLYCREDIT:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_APPLYCREDIT,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"CreditApplyResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_MERCHANT:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"2",HTTP_HOST,
                      [PIRService getMerchantURL:requestModel],HTTP_PATH,
                      @(HTTP_METHOD_GET),HTTP_METHOD,
                      @"MerchantResponse",RESULT_MODEL,nil];
            break;
        default:
            break;
    }
    return result;
}

+ (NSString *)getMerchantURL:(PIRPayModel *)requestModel{
    NSString *result = [NSString stringWithFormat:@"%@%@",[__dataSource.merchantParam objectForKey:@"server_url"],[requestModel valueForKey:@"auth_token"]];
    return result;
}
@end
