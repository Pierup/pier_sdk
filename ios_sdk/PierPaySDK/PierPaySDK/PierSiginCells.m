//
//  PierSiginCells.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierSiginCells.h"
#import "RPFloatingPlaceholderTextField.h"
#import "NSString+Check.h"
#import "PIRViewUtil.h"
#import "PIRDateUtil.h"
#import "PierColor.h"

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

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (NSDictionary *)getUserName{
    NSDictionary *dic = nil;
    NSString *firstName = self.firstNameLabel.text;
    NSString *lastName = self.lastNameLabel.text;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:
           firstName,@"firstName",
           lastName,@"lastName",nil];
    return dic;
}

- (BOOL)checkUserName{
    BOOL result = NO;
    NSDictionary *nameDic = [self getUserName];
    if (![NSString emptyOrNull:[nameDic objectForKey:@"firstName"]]
        && ![NSString emptyOrNull:[nameDic objectForKey:@"lastName"]]) {
        result = YES;
    }else{
        [PIRViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
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

- (BOOL)checkPhone{
    BOOL result = NO;
    NSString *phone = [self getPhone];
    if (phone.length == 10 || phone.length == 11) {
        result = YES;
    }else{
        [PIRViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

@end

@interface PIRSiginEmailNumberCell ()

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *emailLabel;

@end

@implementation PIRSiginEmailNumberCell

- (NSString *)getEmail{
    NSString *email = [self.emailLabel text];
    return email;
}

- (BOOL)checkEmail{
    BOOL result = NO;
    NSString *email = [self getEmail];
    if ([email isValidEMail]) {
        result = YES;
    }else{
        [PIRViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
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

- (BOOL)checkAddress{
    BOOL result = NO;
    NSString *address = [self getAddresss];
    if (![NSString emptyOrNull:address]) {
        result = YES;
    }else{
        [PIRViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

@end

@interface PIRSiginDobCell () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *dobLabel;
/**  */

@end

@implementation PIRSiginDobCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.dobLabel.delegate = self;
}

- (NSString *)getDOB{
    NSString *dob = self.dobLabel.text;
    NSDate *dobData = [PIRDateUtil dateFromString:dob formate:@"MM/dd/yyyy"];
    NSString *resultFormateStr = [PIRDateUtil getStringFormateDate:dobData formatType:@"MM/dd/yyyy"];
    return resultFormateStr;
}

- (BOOL)checkDOB{
    BOOL result = NO;
    NSString *dob = [self getDOB];
    if ([dob checkDOBFormate] == eDOBFormate_available) {
        result = YES;
    }else{
        [PIRViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

#pragma mark -------------------delegate---------------------

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string) {
        if (![string isNumString] && ![NSString emptyOrNull:string]) {
            return NO;
        }
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > 10) {
        return NO;
    }
    if (string.length > 0) {
        textField.text = [self getDobShadowText:newString];
    }else{
        return YES;
    }
    return NO;
}

- (NSString *)getDobShadowText:(NSString *)inputStr{
    NSString *currentStr = inputStr;
    switch (inputStr.length) {
        case 2:
            currentStr = [NSString stringWithFormat:@"%@/",inputStr];
            break;
        case 5:
            currentStr = [NSString stringWithFormat:@"%@/",inputStr];
            break;
        default:
            currentStr = inputStr;
            break;
    }
    return currentStr;
}

@end

@interface PIRSiginSSNCell () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet RPFloatingPlaceholderTextField *ssnLabel;

@end

@implementation PIRSiginSSNCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.ssnLabel.delegate = self;
    [self.ssnLabel setPlaceholder:@"Social Security Number"];
}

- (NSString *)getSSN{
    NSString *ssn = [self.ssnLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    return ssn;
}

- (BOOL)checkSSN{
    BOOL result = NO;
    NSString *ssn = [self getSSN];
    if ([ssn isValudSSN]) {
        result = YES;
    }else{
        [PIRViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

#pragma mark -------------------delegate---------------------

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string) {
        if (![string isNumString]  && ![NSString emptyOrNull:string]) {
            return NO;
        }
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > 11) {
        return NO;
    }
    if (string.length > 0) {
        textField.text = [self getSSNShadowText:newString];
    }else{
        return YES;
    }
    return NO;
}

- (NSString *)getSSNShadowText:(NSString *)inputStr{
    NSString *currentStr = inputStr;
    switch (inputStr.length) {
        case 3:
            currentStr = [NSString stringWithFormat:@"%@ ",inputStr];
            break;
        case 6:
            currentStr = [NSString stringWithFormat:@"%@ ",inputStr];
            break;
        default:
            currentStr = inputStr;
            break;
    }
    return currentStr;
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

- (BOOL)checkPWD{
    BOOL result = NO;
    NSString *pwd = [self getPassword];
    if (pwd.length > 5) {
        result = YES;
    }else{
        [PIRViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

@end

@interface PIRSiginSubmitCell ()

@property (nonatomic, weak) IBOutlet UIButton *submitButton;

@end

@implementation PIRSiginSubmitCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.submitButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *submitbtnImg = [PIRViewUtil getImageByView:self.submitButton];
    [self.submitButton setBackgroundImage:submitbtnImg forState:UIControlStateNormal];
    [self.submitButton.layer setCornerRadius:5.0f];
    [self.submitButton.layer setMasksToBounds:YES];
    UIImage *subBtnImg = [PIRViewUtil getImageByView:self.submitButton];
    [self.submitButton setBackgroundImage:subBtnImg forState:UIControlStateNormal];
}

- (IBAction)submitUserInfo:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitUserInfo)]) {
        [self.delegate submitUserInfo];
    }
}

@end