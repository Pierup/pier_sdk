//
//  MerchantModel.h
//  PierPayDemo
//
//  Created by zyma on 4/5/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, copy) NSString *amount;         //amount
@property (nonatomic, copy) NSString *image;          //image_url
@property (nonatomic, copy) NSString *currency;       //currency of amount
@property (nonatomic, copy) NSString *server_url;     //server_url
@property (nonatomic, copy) NSString *shop_name;      //shop name

@end


@interface MerchantModel : NSObject

@property (nonatomic, copy) NSString *phone;                 //phone
@property (nonatomic, copy) NSString *country_code;          //countryCode
@property (nonatomic, copy) NSString *merchant_id;           //your id in pier
@property (nonatomic, copy) NSString *product_small_url;     //merchant_pic_url
@property (nonatomic, copy) NSString *business_name;         //merchant_name
@property (nonatomic, strong) NSArray  *shopListModelArray;  //ShopListModel

@end
