//
//  ProductCartViewController.h
//  PierPayDemo
//
//  Created by zyma on 4/5/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCartViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *cartProductArray; //ProductModel
@property (nonatomic, copy) NSString  *merchant_id;

@end
