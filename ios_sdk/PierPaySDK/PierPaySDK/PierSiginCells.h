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

- (NSDictionary *)getUserName;
- (BOOL)checkUserName;

@end

@interface PierSiginPhoneNumberCell : PierSiginCells

- (NSString *)getPhone;
- (BOOL)checkPhone;

@end

@interface PierSiginEmailNumberCell : PierSiginCells

- (NSString *)getEmail;
- (BOOL)checkEmail;

@end

@interface PierSiginAddressCell : PierSiginCells

- (NSString *)getAddresss;
- (BOOL)checkAddress;

@end

@interface PierSiginDobCell : PierSiginCells

- (NSString *)getDOB;
- (BOOL)checkDOB;

@end

@interface PierSiginSSNCell : PierSiginCells

- (NSString *)getSSN;
- (BOOL)checkSSN;

@end

@interface PierSiginPWDCell : PierSiginCells

- (NSString *)getPassword;
- (BOOL)checkPWD;

@end

@interface PierSiginSubmitCell : PierSiginCells

@end
