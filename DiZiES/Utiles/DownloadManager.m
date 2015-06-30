//
//  DownloadManager.m
//  DiZiES
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DownloadManager.h"
#import "Tools.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface DownloadManager ()<ASIHTTPRequestDelegate, ASIProgressDelegate>

@property (nonatomic, strong) ASINetworkQueue *queue;
// 当前正在下载的队列
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation DownloadManager

+ (DownloadManager *)shareInstance
{
    static DownloadManager *downloader   = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch , ^{
        downloader                  = [[DownloadManager alloc] init];
    });
    return downloader;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.queue                  = [[ASINetworkQueue alloc] init];
        self.queue.maxConcurrentOperationCount      = 1;
        [self.queue setShowAccurateProgress:YES];
        [self.queue go];
        //        [self _resumeDownloadTmpFile];
    }
    return self;
}

- (void)_resumeDownloadTmpFile
{//  NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:self.DataArray];
    NSArray *array                  = [NSKeyedUnarchiver unarchiveObjectWithFile:[FileManager getResumeDownloadInfoPlistFile]];
    for (int i = 0; i < array.count; i++)
    {
        id item                     = [array objectAtIndex:i];
        if ([item isKindOfClass:[FloderDataModel class]])
        {
            FloderDataModel *model  = (FloderDataModel *)item;
            [self downloadFileWithFileModel:model];
        }
    }
    
}

#pragma mark - Public Methods
- (void)downloadFileWithFileModel:(FloderDataModel *)model
{
    NSAssert(model.url.length > 0, @"download url is not valid");
    [self.listArray addObject:model];
    NSLog(@"url %@ star download", model.url);
    NSURL *nUrl             = [NSURL URLWithString:model.url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nUrl];
    request.userInfo        = @{@"key":model.url};
    request.delegate        = self;
    [request setAllowResumeForFileDownloads:YES];
    request.downloadProgressDelegate = self;
    [request setDownloadDestinationPath:[FileManager getDownloadDirPathWithFloderModel:model]];
    [request setTemporaryFileDownloadPath:[FileManager getTempDownloadFileWithFloderModel:model]];
    [self.queue addOperation:request];
}

- (void)suspendRequestWithFileModel:(FloderDataModel *)model
{
    NSArray *array          = [self.queue operations];
    ASIHTTPRequest *request;
    for (int i = 0; i < array.count; i++)
    {
        ASIHTTPRequest *tRequest        = [array objectAtIndex:i];
        if ([[tRequest.userInfo objectForKey:@"key"] isEqualToString:model.url])
        {
            request         = tRequest;
        }
    }
    if (request) {
        [request clearDelegatesAndCancel];
    }
}


- (void)resumeRequestWithFileMode:(FloderDataModel *)model
{
    NSArray *array          = [self.queue operations];
    ASIHTTPRequest *request;
    for (int i = 0; i < array.count; i++)
    {
        ASIHTTPRequest *tRequest        = [array objectAtIndex:i];
        if ([[tRequest.userInfo objectForKey:@"key"] isEqualToString:model.url])
        {
            request         = tRequest;
        }
    }
    if (request) {
        [request start];
    }
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"url %@ request start", [request.userInfo objectForKey:@"key"]);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"url %@ request finished", [request.userInfo objectForKey:@"key"]);
    for (int i = 0; i < _listArray.count; i++)
    {
        ASIHTTPRequest *tRequest        = [_listArray objectAtIndex:i];
        if ([[tRequest.userInfo objectForKey:@"key"] isEqualToString:[request.userInfo objectForKey:@"key"]])
        {
            NSLog(@"url %@", [tRequest.userInfo objectForKey:@"key"]);
            [_listArray removeObjectAtIndex:i];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"url %@ request failed", [request.userInfo objectForKey:@"key"]);
}

//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//
//}

#pragma mark - ASIProgressDelegate
- (void)setProgress:(float)newProgress
{
    NSLog(@"%f", newProgress);
}

@end