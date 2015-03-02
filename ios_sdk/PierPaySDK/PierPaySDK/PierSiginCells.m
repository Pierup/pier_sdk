//
//  PierSiginCells.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierSiginCells.h"
#import "RPFloatingPlaceholderTextField.h"

@implementation PIRSiginCellModel

@end

@implementation PierSiginCells

- (void)updateCell:(PIRSiginCellModel *)model indexPath:(NSIndexPath *)index{
    
}

@end


@interface PIRSiginNameCell ()

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *firstNameLabel;
@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *lastNameLabel;

@end

@implementation PIRSiginNameCell

- (NSDictionary *)getUserName{
    NSDictionary *dic = nil;
    NSString *firstName = self.firstNameLabel.text;
    NSString *lastName = self.lastNameLabel.text;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
           firstName,@"firstName",
           lastName,@"lastName",nil];
    return dic;
}

@end

@interface PIRSiginPhoneNumberCell ()

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *phoneLabel;

@end

@implementation PIRSiginPhoneNumberCell

- (NSString *)getPhone{
    NSString *phone = self.phoneLabel.text;
    return phone;
}

@end

@interface PIRSiginAddressCell ()

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *addressLabel;

@end

@implementation PIRSiginAddressCell

- (NSString *)getAddresss{
    NSString *address = self.addressLabel.text;
    return address;
}

@end

@interface PIRSiginDobCell ()

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *dobLabel;

@end

@implementation PIRSiginDobCell

- (NSString *)getDOB{
    NSString *dob = self.dobLabel.text;
    return dob;
}

@end

@interface PIRSiginSSNCell ()

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *ssnLabel;

@end

@implementation PIRSiginSSNCell

- (NSString *)getSSN{
    NSString *ssn = self.ssnLabel.text;
    return ssn;
}

@end

@interface PIRSiginPWDCell ()

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *passwordLabel;

@end

@implementation PIRSiginPWDCell

- (NSString *)getPassword{
    NSString *password = self.passwordLabel.text;
    return password;
}

@end

@interface PIRSiginSubmitCell ()

@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@end

@implementation PIRSiginSubmitCell

- (IBAction)submitUserInfo:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitUserInfo)]) {
        [self.delegate submitUserInfo];
    }
}

@end