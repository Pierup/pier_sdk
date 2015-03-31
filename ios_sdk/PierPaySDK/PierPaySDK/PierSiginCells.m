//
//  PierSiginCells.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierSiginCells.h"
#import "PierFloatingPlaceholderTextField.h"
#import "NSString+PierCheck.h"
#import "PierViewUtil.h"
#import "PierDateUtil.h"
#import "PierColor.h"
#import "PierFont.h"

@implementation PierSiginCellModel

@end

@implementation PierSiginCells

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index{
    
}

@end


@interface PierSiginNameCell ()

@property (nonatomic, weak) IBOutlet PierFloatingPlaceholderTextField *firstNameLabel;
@property (nonatomic, weak) IBOutlet PierFloatingPlaceholderTextField *lastNameLabel;

@end

@implementation PierSiginNameCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.firstNameLabel setFont:[PierFont customFontWithSize:17]];
    [self.lastNameLabel setFont:[PierFont customFontWithSize:17]];
}

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index{
    [self.firstNameLabel setText:model.firstName];
    [self.lastNameLabel setText:model.lastName];
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
        [PierViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

@end

@interface PierSiginPhoneNumberCell ()

@property (nonatomic, weak) IBOutlet PierFloatingPlaceholderTextField *phoneLabel;

@end

@implementation PierSiginPhoneNumberCell

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index{
    
}

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
        [PierViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

@end

@interface PierSiginEmailNumberCell ()

@property (nonatomic, weak) IBOutlet PierFloatingPlaceholderTextField *emailLabel;

@end

@implementation PierSiginEmailNumberCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.emailLabel setFont:[PierFont customFontWithSize:17]];
}

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index{
    [self.emailLabel setText:model.email];
}

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
        [PierViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

@end

@interface PierSiginAddressCell ()

@property (nonatomic, weak) IBOutlet PierFloatingPlaceholderTextField *addressLabel;

@end

@implementation PierSiginAddressCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.addressLabel setFont:[PierFont customFontWithSize:17]];
}

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index{
    [self.addressLabel setText:model.address];
}

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
        [PierViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

@end

@interface PierSiginDobCell () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet PierFloatingPlaceholderTextField *dobLabel;
/**  */

@end

@implementation PierSiginDobCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.dobLabel.delegate = self;
    [self.dobLabel setFont:[PierFont customFontWithSize:17]];
}

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index{
    [self.dobLabel setText:model.dob];
}

- (NSString *)getDOB{
    NSString *dob = self.dobLabel.text;
    NSDate *dobData = [PierDateUtil dateFromString:dob formate:@"MM/dd/yyyy"];
    NSString *resultFormateStr = [PierDateUtil getStringFormateDate:dobData formatType:@"MM/dd/yyyy"];
    return resultFormateStr;
}

- (BOOL)checkDOB{
    BOOL result = NO;
    NSString *dob = [self getDOB];
    if ([dob checkDOBFormate] == eDOBFormate_available) {
        result = YES;
    }else{
        [PierViewUtil shakeView:self.contentView];
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

@interface PierSiginSSNCell () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet PierFloatingPlaceholderTextField *ssnLabel;

@end

@implementation PierSiginSSNCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.ssnLabel.delegate = self;
    [self.ssnLabel setPlaceholder:@"Social Security Number"];
    [self.ssnLabel setFont:[PierFont customFontWithSize:17]];
}

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index{
    [self.ssnLabel setText:model.ssn];
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
        [PierViewUtil shakeView:self.contentView];
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

@interface PierSiginPWDCell ()

@property (nonatomic, weak) IBOutlet PierFloatingPlaceholderTextField *passwordLabel;

@end

@implementation PierSiginPWDCell

- (void)updateCell:(PierSiginCellModel *)model indexPath:(NSIndexPath *)index{
    
}

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
        [PierViewUtil shakeView:self.contentView];
        result = NO;
    }
    return result;
}

@end

@interface PierSiginSubmitCell ()

@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UILabel *summitRemarkLabel;

@end

@implementation PierSiginSubmitCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.submitButton setBackgroundColor:[PierColor lightPurpleColor]];
    UIImage *submitbtnImg = [PierViewUtil getImageByView:self.submitButton];
    [self.submitButton setBackgroundImage:submitbtnImg forState:UIControlStateNormal];
    [self.submitButton.layer setCornerRadius:5.0f];
    [self.submitButton.layer setMasksToBounds:YES];
    UIImage *subBtnImg = [PierViewUtil getImageByView:self.submitButton];
    [self.submitButton setBackgroundImage:subBtnImg forState:UIControlStateNormal];
    
    [self.summitRemarkLabel setFont:[PierFont customFontWithSize:12]];
    [self.submitButton.titleLabel setFont:[PierFont customFontWithSize:20]];
}

- (IBAction)submitUserInfo:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitUserInfo)]) {
        [self.delegate submitUserInfo];
    }
}

@end