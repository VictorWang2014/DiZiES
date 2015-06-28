//
//  DownloadingCell.m
//  DiZiES
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DownloadingCell.h"

@interface DownloadingCell ()

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSTimer   *timer;

@end

@implementation DownloadingCell

- (void)awakeFromNib {
    // Initialization code
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)downloadButtonClick:(UIButton *)sender
{
    if (self.fileModel.downloadState  == DownloadStateDownloading)// 正在下载 则点击后暂停
    {
        NSURLSessionDownloadTask *task = [[[DownloadManager shareInstance] downloadTasksDic] objectForKey:[self.fileModel.fileNameStr stringByDeletingPathExtension]];
        if (task == nil)
        {
            [[DownloadManager shareInstance] downloadWithFile:self.fileModel downloadSuccess:^(id data) {
                if (_adelegate && [_adelegate respondsToSelector:@selector(downloadingSuccess:)]) {
                    [_adelegate downloadingSuccess:self];
                }
            }];
            task = [[[DownloadManager shareInstance] downloadTasksDic] objectForKey:[self.fileModel.fileNameStr stringByDeletingPathExtension]];
        }
        [task suspend];
        self.downloadTask = task;
        [self.timer setFireDate:[NSDate distantPast]];
        [self.downloadButton setTitle:@"暂停" forState:UIControlStateNormal];
    }else if (self.fileModel.downloadState == DownloadStateSuspend)// 如果暂停，则点击后开始下载
    {
        NSURLSessionDownloadTask *task = [[[DownloadManager shareInstance] downloadTasksDic] objectForKey:[self.fileModel.fileNameStr stringByDeletingPathExtension]];
        if (task == nil)
        {
            [[DownloadManager shareInstance] downloadWithFile:self.fileModel downloadSuccess:^(id data) {
                if (_adelegate && [_adelegate respondsToSelector:@selector(downloadingSuccess:)]) {
                    [_adelegate downloadingSuccess:self];
                    [self.downloadButton setTitle:@"下载完成" forState:UIControlStateNormal];
                }
            }];
            task = [[[DownloadManager shareInstance] downloadTasksDic] objectForKey:[self.fileModel.fileNameStr stringByDeletingPathExtension]];
        }else
        {
            [task resume];
        }
        self.downloadTask = task;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.downloadButton setTitle:@"正在下载" forState:UIControlStateNormal];
    }
}

- (void)updateProgress
{
    float percentage = self.downloadTask.countOfBytesReceived*100.0/[self.fileModel.fileSize floatValue];
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%", percentage];
}

@end
