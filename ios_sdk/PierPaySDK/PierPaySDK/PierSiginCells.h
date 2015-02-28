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

@end

@protocol PIRSiginCellsDelegate <NSObject>

@end


@interface PierSiginCells : UITableViewCell

@property (nonatomic, weak) id<PIRSiginCellsDelegate> delegate;
- (void)updateCell:(PIRSiginCellModel *)model indexPath:(NSIndexPath *)index;

@end

@interface PIRSiginNameCell : PierSiginCells

@end

@interface PIRSiginPWDCell : PierSiginCells

@end