//
//  DownloadingCell.m
//  DiZiES
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DownloadingCell.h"
#import "Tools.h"

@interface DownloadingCell ()<ASIProgressDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSTimer   *timer;

@end

@implementation DownloadingCell

- (void)awakeFromNib {
    // Initialization code
    self.timer                  = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)setFileModel:(FloderDataModel *)fileModel
{
    if (_fileModel != fileModel)
    {
        _fileModel = fileModel;
        if ([FileManager fileIsExistAtPath:[FileManager getTempDownloadFilePathWithFloderModel:fileModel]])
        {
            self.downloadState  = DownloadStateDownloading;
        }else
        {
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
    if (self.downloadState == DownloadStateNone) {
        [[DownloadManager shareInstance] downloadFileWithFileModel:_fileModel];
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    if (self.fileModel.downloadState  == DownloadStateDownloading)// 正在下载 则点击后暂停
    {
        [self.timer setFireDate:[NSDate distantPast]];
        self.downloadState          = DownloadStateSuspend;
    }else if (self.fileModel.downloadState == DownloadStateSuspend)// 如果暂停，则点击后开始下载
    {
        self.downloadState          = DownloadStateDownloading;
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)setDownloadState:(DownloadState)downloadState
{
    _downloadState = downloadState;
    if (downloadState == DownloadStateNone)
    {
        [self.downloadButton setTitle:@"点击下载" forState:UIControlStateNormal];
    }else if (downloadState == DownloadStateSuspend)
    {
        [self.downloadButton setTitle:@"暂停下载" forState:UIControlStateNormal];
    }else if (downloadState == DownloadStateDownloading)
    {
        [self.downloadButton setTitle:@"正在下载" forState:UIControlStateNormal];
    }
    else if (downloadState == DownloadStateDownloadWait)
    {
        [self.downloadButton setTitle:@"等待下载" forState:UIControlStateNormal];
    }else if (downloadState == DownloadStateDownloadError)
    {
        [self.downloadButton setTitle:@"下载失败，点击重新下载" forState:UIControlStateNormal];
    }else if (downloadState == DownloadStateDownloaded)
    {
        [self.downloadButton setTitle:@"下载完成" forState:UIControlStateNormal];
    }
}

- (void)updateProgress
{
    ASIHTTPRequest *h               = [[DownloadManager shareInstance] getDownloadRequestWithFileModel:_fileModel];
    h.downloadProgressDelegate      = self;
    [h updateDownloadProgress];
    NSLog(@"url %@", _fileModel.fileNameStr);
}

- (void)setProgress:(float)newProgress
{
    NSLog(@"%f", newProgress);
}
@end
