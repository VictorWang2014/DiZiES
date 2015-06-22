//
//  DownloadingCell.h
//  DiZiES
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadManager.h"

@interface DownloadingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *fileImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *progressLabel;

@property (strong, nonatomic) IBOutlet UIImageView *sepLineImageView;

@property (strong, nonatomic) IBOutlet UIButton *downloadButton;

@property (nonatomic, strong) FileModel *fileModel;

@end
