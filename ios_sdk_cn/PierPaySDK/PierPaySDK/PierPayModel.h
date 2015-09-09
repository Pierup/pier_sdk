//
//  PierPayModel.h
//  PierPaySDK
//
//  Created by zyma on 1/26/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierJSONModel.h"

@interface PierPayModel : PierJSONModel
//output
@property(nonatomic, copy, readwrite) NSString *code;
@property(nonatomic, copy, readwrite) NSString *message;

@end

#pragma mark - ------------------- PIER_API_SAVE_ORDER_INFO -------------------
#pragma mark - Request
@interface PierRequestSaveOrderInfoRequest : PierPayModel

@property(nonatomic, copy, readwrite) NSString *order_id;
@property(nonatomic, copy, readwrite) NSString *api_id;
@property(nonatomic, copy, readwrite) NSString *merchant_id;
@property(nonatomic, copy, readwrite) NSString *amount;
@property(nonatomic, copy, readwrite) NSString *order_detail;
@property(nonatomic, copy, readwrite) NSString *return_url;

@end

#pragma mark - Response
@interface PierRequestSaveOrderInfoResponse : PierPayModel

@property(nonatomic, copy, readonly) NSString *order_id;

@end



