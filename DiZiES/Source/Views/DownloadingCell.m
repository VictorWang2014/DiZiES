//
//  DownloadingCell.m
//  DiZiES
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DownloadingCell.h"
#import "Tools.h"

@interface DownloadingCell ()

@end

@implementation DownloadingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setFileModel:(FloderDataModel *)fileModel
{
    if (_fileModel != fileModel)
    {
        _fileModel = fileModel;
        if ([FileManager fileIsExistAtPath:[FileManager getTempDownloadFilePathWithFloderModel:fileModel]] && _fileModel.downloadState == DownloadStateDownloading)
        {
            _fileModel.downloadState = DownloadStateDownloading;
            self.downloadState  = DownloadStateDownloading;
        }
        else if ([FileManager fileIsExistAtPath:[FileManager getTempDownloadFilePathWithFloderModel:fileModel]] && _fileModel.downloadState == DownloadStateDownloadWait)
        {
            _fileModel.downloadState = DownloadStateDownloadWait;
            self.downloadState  = DownloadStateDownloadWait;
        }
        else if ([FileManager fileIsExistAtPath:[FileManager getTempDownloadFilePathWithFloderModel:fileModel]] && _fileModel.downloadState == DownloadStateSuspend)
        {
            _fileModel.downloadState = DownloadStateSuspend;
            self.downloadState  = DownloadStateSuspend;
        }else
        {
            _fileModel.downloadState = DownloadStateNone;
            self.downloadState  = DownloadStateNone;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downloadButtonClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(downloadingCell:data:)]) {
        [_delegate downloadingCell:self data:_fileModel];
    }
}

- (void)setDownloadState:(DownloadState)downloadState
{
    _downloadState                      = downloadState;
    if (downloadState == DownloadStateNone)
    {
        [self.downloadButton setTitle:@"点击下载" forState:UIControlStateNormal];
    }else if (downloadState == DownloadStateSuspend)
    {
        [self.downloadButton setTitle:@"暂停下载" forState:UIControlStateNormal];
    }
    else if (downloadState == DownloadStateDownloadWait)
    {
        [self.downloadButton setTitle:@"等待下载" forState:UIControlStateNormal];
    }
    else if (downloadState == DownloadStateDownloading)
    {
        if (self.fileModel.downloadState == DownloadStateDownloading)
        {
            [self.downloadButton setTitle:@"正在下载" forState:UIControlStateNormal];
        }else
        {
            [self.downloadButton setTitle:@"等待下载" forState:UIControlStateNormal];
        }
    }else if (downloadState == DownloadStateDownloadError)
    {
        [self.downloadButton setTitle:@"下载失败，点击重新下载" forState:UIControlStateNormal];
    }else if (downloadState == DownloadStateDownloaded)
    {
        [self.downloadButton setTitle:@"下载完成" forState:UIControlStateNormal];
    }
}


@end
