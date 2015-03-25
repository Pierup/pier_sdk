//
//  MerchantViewController.h
//  PierPayDemo
//
//  Created by JHR on 15/3/20.
//  Copyright (c) 2015年 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListModel : NSObject

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
@property (nonatomic, strong) NSArray  *shopListModelArray;

@end

@interface MerchantViewController : UIViewController

@end
