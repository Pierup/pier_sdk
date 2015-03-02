//
//  PierSiginCells.h
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PIRSiginCellModel : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *dob;
@property (nonatomic, copy) NSString *ssn;
@property (nonatomic, copy) NSString *password;

@end

@protocol PIRSiginCellsDelegate <NSObject>

- (void)submitUserInfo;

@end


@interface PierSiginCells : UITableViewCell

@property (nonatomic, weak) id<PIRSiginCellsDelegate> delegate;
- (void)updateCell:(PIRSiginCellModel *)model indexPath:(NSIndexPath *)index;

@end

@interface PIRSiginNameCell : PierSiginCells

- (NSDictionary *)getUserName;

@end

@interface PIRSiginPhoneNumberCell : PierSiginCells

- (NSString *)getPhone;

@end

@interface PIRSiginAddressCell : PierSiginCells

- (NSString *)getAddresss;

@end

@interface PIRSiginDobCell : PierSiginCells

- (NSString *)getDOB;

@end

@interface PIRSiginSSNCell : PierSiginCells

- (NSString *)getSSN;

@end

@interface PIRSiginPWDCell : PierSiginCells

- (NSString *)getPassword;

@end

@interface PIRSiginSubmitCell : PierSiginCells

@end