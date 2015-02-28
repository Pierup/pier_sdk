//
//  PierSiginViewModel.m
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import "PierSiginViewModel.h"
#import "PierTools.h"

@implementation PierSiginViewModel

#pragma mark - --------------------初始化--------------------
- (id)init
{
    self = [super self];
    if (self) {
        _sectionArray = [[NSMutableArray alloc] init];
        _cellModel = [[PIRSiginCellModel alloc] init];
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
            [cells addObject:@(eSiginPWDCell)];
            [cells addObject:@(eSiginPWDCell)];
            [cells addObject:@(eSiginPWDCell)];
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
            identifier = @"PIRLoginAccountNameCell";
            break;
        }
        case eSiginPWDCell:
        {
            identifier = @"PIRLoginAccountPWDCell";
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
            PIRSiginNameCell *cell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:0];
            resultCell = cell;
            
            break;
        }
        case eSiginPWDCell:
        {
            PIRSiginPWDCell *cell = [[pierBoundle() loadNibNamed:@"PierSiginCells" owner:self options:nil] objectAtIndex:1];
            resultCell = cell;
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

- (void)configCell:(PierSiginCells *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self.cellDelegate;
    eSiginCellType type = [self getCellType:indexPath];
    switch (type) {
        case eSiginInputUserNameCell:
        case eSiginPWDCell:
        {
            [cell updateCell:self.cellModel indexPath:indexPath];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    eSiginCellType type = [self getCellType:indexPath];
    CGFloat height = 0.f;
    switch (type) {
        case eSiginInputUserNameCell:
        case eSiginPWDCell:
        {
            height = 60.0f;
            break;
        }
        default:
            break;
    }
    
    return height;
}

@end
