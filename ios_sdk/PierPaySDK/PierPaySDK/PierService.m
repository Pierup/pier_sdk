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
#import "PierAlertView.h"
#import "PierLoadingView.h"
#import "PierViewUtil.h"

#define HTTP_METHOD_POST        0   //@"post"
#define HTTP_METHOD_POST_JSON   1   //@"post-json"
#define HTTP_METHOD_PUT         2   //@"put"
#define HTTP_METHOD_GET         3   //@"get"

#define HTTP_HOST               @"host"
#define HTTP_PATH               @"path"
#define HTTP_METHOD             @"method"
#define RESULT_MODEL            @"resultModel"

#define SESSION_EXPIRE      1001
#define PUSSWORD_ERROR      1030
#define USRT_INVALID        1007

/** V1 */
NSString * const PIER_API_SEARCH_USER           = @"/user_api/v1/sdk/search_user";
NSString * const PIER_API_HAS_CREDIT            = @"/user_api/v1/sdk/has_credit";
NSString * const PIER_API_ADD_SUER              = @"/user_api/v1/sdk/add_user";
NSString * const PIER_API_ACTIVITE_DEVICE       = @"/user_api/v1/sdk/activate_device";
NSString * const PIER_API_ADD_ADDRESS           = @"/user_api/v1/sdk/add_address";
NSString * const PIER_API_SET_PASSWORD          = @"/user_api/v1/sdk/set_password";
NSString * const PIER_API_GET_AUTH_TOKEN        = @"/user_api/v1/sdk/get_auth_token";
NSString * const PIER_API_SAVE_DOB_SSN          = @"/user_api/v1/sdk/dob_ssn";
NSString * const PIER_API_GET_AGREEMENT         = @"/user_api/v1/sdk/get_agreement";
NSString * const PIER_API_CREDIT_APPLICATION    = @"/user_api/v1/sdk/application_approve";

/** V2 */
NSString * const PIER_API_TRANSACTION_SMS       = @"/user_api/v2/sdk/transaction_sms";
NSString * const PIER_API_GET_AUTH_TOKEN_V2     = @"/user_api/v2/sdk/get_auth_token";

NSString * const PIER_API_GET_ACTIVITY_CODE     = @"/user_api/v2/user/activation_code";
NSString * const PIER_API_GET_ACTIVITION        = @"/user_api/v2/user/activation";
NSString * const PIER_API_GET_ACTIVITION_REGIST = @"/user_api/v2/user/register_user";
NSString * const PIER_API_GET_UPDATEUSER        = @"/user_api/v2/user/update_user";
NSString * const PIER_API_GET_GETUSER           = @"/user_api/v2/user/get_user";
NSString * const PIER_API_GET_APPLYCREDIT       = @"/user_api/v2/sdk/apply_credit";
NSString * const PIER_API_GET_COUNTRYS          = @"/user_api/v1/user/get_countries";
NSString * const PIER_APU_GET_URLS              = @"/user_api/v2/sdk/get_agreement";

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
    BOOL showAlert = ([[attribute objectForKey:@"show_alert"] integerValue] == 1) ? NO:YES;
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
                    [PierViewUtil toToLoginViewController];
                    break;
                }
                case PUSSWORD_ERROR://账号密码错误
                    
                    break;
                case USRT_INVALID://用户不存在
                {
                    if (showAlert) {
                        NSDictionary *alertParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    @"icon_error",@"title_image_name",
                                                    @"error",@"title",
                                                    [error domain],@"message",nil];
                        [PierAlertView showPierAlertView:self param:alertParam type:ePierAlertViewType_error approve:^(NSString *userInput) {
                            return YES;
                        }];
                    }
                    break;
                }
                default:
                {
                    if (showAlert) {
                        NSDictionary *alertParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    @"icon_error",@"title_image_name",
                                                    @"error",@"title",
                                                    [error domain],@"message",nil];
                        [PierAlertView showPierAlertView:self param:alertParam type:ePierAlertViewType_error approve:^(NSString *userInput) {
                            return YES;
                        }];
                    }
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
        NSDictionary *alertParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"icon_error",@"title_image_name",
                                    @"error",@"title",
                                    [error domain],@"message",nil];
        [PierAlertView showPierAlertView:self param:alertParam type:ePierAlertViewType_error approve:^(NSString *userInput) {
            return YES;
        }];
    }
    failed(error);
}

+ (NSDictionary *)getPathAndMethodByType:(ePIER_API_Type)apiType requestModel:(PierPayModel *)requestModel{
    NSDictionary *result = nil;
    switch (apiType) {
        case ePIER_API_TRANSACTION_SMS:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_TRANSACTION_SMS,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierTransactionSMSResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_AUTH_TOKEN_V2:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_AUTH_TOKEN_V2,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierGetAuthTokenV2Response",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_ACTIVITY_CODE:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_ACTIVITY_CODE,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierGetRegisterCodeResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_ACTIVITION:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_ACTIVITION,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierRegSMSActiveResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_ACTIVITION_REGIST:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_ACTIVITION_REGIST,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierRegisterResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_UPDATEUSER:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_UPDATEUSER,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierUpdateResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_GETUSER:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_GETUSER,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierGetUserResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_APPLYCREDIT:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_APPLYCREDIT,HTTP_PATH,
                      @(HTTP_METHOD_POST_JSON),HTTP_METHOD,
                      @"PierCreditApplyResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_MERCHANT:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"2",HTTP_HOST,
                      [PierService getMerchantURL:requestModel],HTTP_PATH,
                      @(HTTP_METHOD_GET),HTTP_METHOD,
                      @"PierMerchantResponse",RESULT_MODEL,nil];
            break;
        case ePIER_API_GET_COUNTRYS:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_API_GET_COUNTRYS,HTTP_PATH,
                      @(HTTP_METHOD_GET),HTTP_METHOD,
                      @"PierCountryCodeResponse",RESULT_MODEL,nil];
            break;
        case ePIER_APU_GET_URLS:
            result = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"1",HTTP_HOST,
                      PIER_APU_GET_URLS,HTTP_PATH,
                      @(HTTP_METHOD_GET),HTTP_METHOD,
                      @"PierUserAgreementResponse",RESULT_MODEL,nil];
            break;
        default:
            break;
    }
    return result;
}

+ (NSString *)getMerchantURL:(PierPayModel *)requestModel{
    NSString *urlStr = [__pierDataSource.merchantParam objectForKey:DATASOURCES_SERVER_URL];
    NSString *amount = [__pierDataSource.merchantParam objectForKey:DATASOURCES_AMOUNT];
    NSString *authToken = [requestModel valueForKey:@"auth_token"];
    NSString *currency = [__pierDataSource.merchantParam objectForKey:DATASOURCES_CURRENCY];
    NSString *orderid = [__pierDataSource.merchantParam objectForKey:DATASOURCES_ORDERID];
    NSString *result = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", urlStr,amount,authToken,currency,orderid];
    return result;
}
@end
