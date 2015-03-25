//
//  PierSiginCells.h
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PierSiginCellModel : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *dob;
@property (nonatomic, copy) NSString *ssn;
@property (nonatomic, copy) NSString *password;

@end

@protocol PierSiginCellsDelegate <NSObject>

- (void)submitUserInfo;

@end


@interface PierSiginCells : UITableViewCell

@property (nonatomic, weak) id<PierSiginCellsDelegate> delegate;
- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index;

@end

@interface PierSiginNameCell : PierSiginCells

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index;
- (NSDictionary *)getUserName;
- (BOOL)checkUserName;

@end

@interface PierSiginPhoneNumberCell : PierSiginCells

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index;
- (NSString *)getPhone;
- (BOOL)checkPhone;

@end

@interface PierSiginEmailNumberCell : PierSiginCells

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index;
- (NSString *)getEmail;
- (BOOL)checkEmail;

@end

@interface PierSiginAddressCell : PierSiginCells

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index;
- (NSString *)getAddresss;
- (BOOL)checkAddress;

@end

@interface PierSiginDobCell : PierSiginCells

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index;
- (NSString *)getDOB;
- (BOOL)checkDOB;

@end

@interface PierSiginSSNCell : PierSiginCells

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index;
- (NSString *)getSSN;
- (BOOL)checkSSN;

@end

@interface PierSiginPWDCell : PierSiginCells

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index;
- (NSString *)getPassword;
- (BOOL)checkPWD;

@end

@interface PierSiginSubmitCell : PierSiginCells

@end
