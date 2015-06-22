//
//  DownloadingCell.m
//  DiZiES
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DownloadingCell.h"

@implementation DownloadingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downloadButtonClick:(UIButton *)sender
{
    if (self.fileModel.downloadState  == DownloadStateDownloading)// 正在下载 则点击后暂停
    {
        
    }else if (self.fileModel.downloadState == DownloadStateSuspend)// 如果暂停，则点击后开始下载
    {
        
    }
}

@end
