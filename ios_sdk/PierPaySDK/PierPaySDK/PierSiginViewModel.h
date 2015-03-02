//
//  PierSiginViewModel.h
//  PierPaySDK
//
//  Created by zyma on 2/28/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PierSiginCells.h"

typedef NS_ENUM(NSInteger, eSiginCellSection) {
    eSiginSection
};

typedef NS_ENUM(NSInteger, eSiginCellType) {
    eSiginInputUserNameCell,
    eSiginPhoneNumberCell,
    eSiginAddressCell,
    eSiginDobCell,
    eSiginSSNCell,
    eSiginPWDCell,
    eSiginSubmitCell
};

@interface PierSiginViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, weak) id<PIRSiginCellsDelegate> cellDelegate;

- (void)createTableData;
- (NSString *)getIdentifierByCellIndex:(NSIndexPath *)indexPath;
- (PierSiginCells *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (PierSiginCells *)footViewForRowAtSection:(NSInteger)section;
- (void)configCell:(PierSiginCells *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (PIRSiginCellModel *)getSiginCellModel;

@end
