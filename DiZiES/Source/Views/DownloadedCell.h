//
//  DownloadedCell.h
//  DiZiES
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDataModle.h"

@class DownloadedCell;
@protocol DownloadedCellDelegate <NSObject>

- (void)downloadedCellDelete:(DownloadedCell *)cell;

@end

@interface DownloadedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *fileImageView;

@property (strong, nonatomic) IBOutlet UIImageView *sepLineImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgLineLayoutConstrains;

@property (nonatomic, strong) FloderDataModel *fileModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) id<DownloadedCellDelegate>delegate;

@end
