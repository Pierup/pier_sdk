//
//  PierSiginViewModel.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierSiginViewModel.h"
#import "PierTools.h"
#import "PierPayModel.h"
#import "PierDateUtil.h"

@interface PierSiginViewModel ()

@property (nonatomic, strong) PierSiginCellModel *cellModel;
@property (nonatomic, strong) PierSiginNameCell *nameCell;
@property (nonatomic, strong) PierSiginPhoneNumberCell *phoneCell;
@property (nonatomic, strong) PierSiginEmailNumberCell *emailCell;
@property (nonatomic, strong) PierSiginAddressCell *addressCell;
@property (nonatomic, strong) PierSiginDobCell *DOBCell;
@property (nonatomic, strong) PierSiginSSNCell *SSNCell;
@property (nonatomic, strong) PierSiginPWDCell *pwdCell;
@property (nonatomic, strong) PierSiginSubmitCell *submitCell;

@end

@implementation PierSiginViewModel

#pragma mark - --------------------初始化--------------------
- (id)init
{
    self = [super self];
    if (self) {
        _sectionArray = [[NSMutableArray alloc] init];
        _cellModel = [[PierSiginCellModel alloc] init];
    }
    
    return self;
}

#pragma mark - --------------------退出清空--------------------

#pragma mark - --------------------System--------------------

#pragma mark - --------------------功能函数--------------------

- (NSDictionary *)addCellsToSection:(eSiginCellSection)sectionType
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    switch (sectionType) {
        case eSiginSection:
        {
            __block NSMutableArray *cells = [NSMutableArray array];
            [cells addObject:@(eSiginInputUserNameCell)];
            [cells addObject:@(eSiginEmailCell)];
            [cells addObject:@(eSiginAddressCell)];
            [cells addObject:@(eSiginDobCell)];
            [cells addObject:@(eSiginSSNCell)];
            [cells addObject:@(eSiginSubmitCell)];
            [dictionary setObject:cells forKey:@(sectionType)];
            break;
        }
        default:
            break;
    }
    
    return dictionary;
}

- (eSiginCellType)getCellType:(NSIndexPath *)indexPath
{
    eSiginCellType cellType = 0;
    NSNumber *key = [[_sectionArray[indexPath.section] allKeys] firstObject];
    NSArray *cells = [_sectionArray[indexPath.section] objectForKey:key];
    NSNumber *type = [cells objectAtIndex:indexPath.row];
    cellType = type.unsignedIntegerValue;
    
    return cellType;
}

- (NSString *)getIdentifierWithType:(eSiginCellType)type
{
    NSString *identifier;
    switch (type) {
        case eSiginInputUserNameCell:
        {
            identifier = @"PierSiginNameCell";
            break;
        }
        case eSiginPhoneNumberCell:{
            identifier = @"PierSiginPhoneNumberCell";
            break;
        }
        case eSiginEmailCell:{
            identifier = @"PierSiginEmailNumberCell";
            break;
        }
        case eSiginAddressCell:{
            identifier = @"PierSiginAddressCell";
            break;
        }
        case eSiginDobCell:{
            identifier = @"PierSiginDobCell";
            break;
        }
        case eSiginSSNCell:{
            identifier = @"PierSiginSSNCell";
            break;
        }
        case eSiginPWDCell:
        {
            identifier = @"PierSiginPWDCell";
            break;
        }
        case eSiginSubmitCell:{
            identifier = @"PierSiginSubmitCell";
            break;
        }
        default:
            break;
    }
    
    return identifier;
}

- (PierSiginCells *)getCellWithType:(eSiginCellType)type
{
    PierSiginCells *resultCell = nil;
    switch (type) {
        case eSiginInputUserNameCell:
        {
            _nameCell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:0];
            resultCell = _nameCell;
            
            break;
        }
        case eSiginPhoneNumberCell:{
            _phoneCell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:1];
            resultCell = _phoneCell;
            break;
        }
        case eSiginEmailCell:{
            _emailCell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:7];
            resultCell = _emailCell;
            break;
        }
        case eSiginAddressCell:{
            _addressCell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:2];
            resultCell = _addressCell;
            break;
        }
        case eSiginDobCell:{
            _DOBCell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:3];
            resultCell = _DOBCell;
            break;
        }
        case eSiginSSNCell:{
            _SSNCell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:4];
            resultCell = _SSNCell;
            break;
        }
        case eSiginPWDCell:
        {
            _pwdCell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:5];
            resultCell = _pwdCell;
            break;
        }
        case eSiginSubmitCell:{
            _submitCell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:6];
            resultCell = _submitCell;
            break;
        }
        default:
            return resultCell;
            break;
    }
    return resultCell;
}
#pragma mark - --------------------按钮事件--------------------

#pragma mark - --------------------代理方法--------------------

#pragma mark - --------------------属性相关--------------------

#pragma mark - --------------------接口API--------------------

/** create tableview*/
- (void)createTableData
{
    _sectionArray = [[NSMutableArray alloc] init];
    [_sectionArray addObject:[self addCellsToSection:eSiginSection]];
}

/** config cells */
- (NSString *)getIdentifierByCellIndex:(NSIndexPath *)indexPath
{
    return [self getIdentifierWithType:[self getCellType:indexPath]];
}

- (PierSiginCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellWithType:[self getCellType:indexPath]];
}

- (PierSiginCells *)footViewForRowAtSection:(NSInteger)section{
    PierSiginSubmitCell *cell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:6];
    cell.delegate = self.cellDelegate;
    return cell;
}

- (void)configCell:(PierSiginCells *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self.cellDelegate;
    eSiginCellType type = [self getCellType:indexPath];
    switch (type) {
        case eSiginInputUserNameCell:
        {
            break;
        }
        case eSiginPhoneNumberCell:{
            break;
        }
        case eSiginEmailCell:{
            break;
        }
        case eSiginAddressCell:{
            break;
        }
        case eSiginDobCell:{
            break;
        }
        case eSiginSSNCell:{
            break;
        }
        case eSiginPWDCell:
        {
            break;
        }
        case eSiginSubmitCell:{
            break;
        }
        default:
            break;
    }
    [cell updateCell:self.cellModel indexPath:indexPath];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eSiginCellType type = [self getCellType:indexPath];
    CGFloat height = 0.f;
    switch (type) {
        case eSiginInputUserNameCell:
        {
            height = 75;
            break;
        }
        case eSiginPhoneNumberCell:{
            height = 75;
            break;
        }
        case eSiginEmailCell:{
            height = 75;
            break;
        }
        case eSiginAddressCell:{
            height = 75;
            break;
        }
        case eSiginDobCell:{
            height = 75;
            break;
        }
        case eSiginSSNCell:{
            height = 75;
            break;
        }
        case eSiginPWDCell:
        {
            height = 75;
            break;
        }
        case eSiginSubmitCell:{
            height = 104;
            break;
        }
        default:
            break;
    }
    
    return height;
}

- (PierSiginCellModel *)getSiginCellModel{
    NSDictionary *nameDic = [self.nameCell getUserName];
    self.cellModel.firstName = [nameDic objectForKey:@"firstName"];
    self.cellModel.lastName = [nameDic objectForKey:@"lastName"];
    self.cellModel.email = [self.emailCell getEmail];
    self.cellModel.address = [self.addressCell getAddresss];
    self.cellModel.dob = [self.DOBCell getDOB];
    self.cellModel.ssn = [self.SSNCell getSSN];
    self.cellModel.password = [self.pwdCell getPassword];
    return self.cellModel;
}

- (void)setSiginCellModel:(PierGetUserResponse *)model{
    self.cellModel.firstName = model.first_name;
    self.cellModel.lastName = model.last_name;
    self.cellModel.email = model.email;
    self.cellModel.ssn = model.ssn;
    NSString *formateDOB = [PierDateUtil getStringTimeByServiceFormate:model.dob formate:@"MM/dd/yyyy"];
    self.cellModel.dob = formateDOB;
    self.cellModel.address = model.address;
}

- (BOOL)checkUserInfo{
//    BOOL checkName  = [self.nameCell checkUserName];
//    BOOL checkPhone = [self.phoneCell checkPhone];
    BOOL result = [self.nameCell checkUserName] && [self.emailCell checkEmail] && [self.addressCell checkAddress] && [self.DOBCell checkDOB] && [self.SSNCell checkSSN];
    
    return result;
}

@end
