//
//  DownloadManager.m
//  DiZiES
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DownloadManager.h"
#import "Tools.h"

@interface DownloadManager ()

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

- (int)queueCount
{
    return [[self.queue operations] count];
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
- (ASIHTTPRequest *)getDownloadRequestWithFileModel:(FloderDataModel *)model
{
    NSArray *array          = [self.queue operations];
    for (int i = 0; i < array.count; i++)
    {
        ASIHTTPRequest *tRequest        = [array objectAtIndex:i];
        if ([[tRequest.userInfo objectForKey:@"key"] isEqualToString:model.url])
        {
            return tRequest;
        }
    }
    return nil;
}

- (void)downloadFileWithFileModel:(FloderDataModel *)model
{
    [self downloadFileWithFileModel:model delegate:nil];
}

- (void)downloadFileWithFileModel:(FloderDataModel *)model delegate:(id)delegate
{
    NSAssert(model.url.length > 0, @"download url is not valid");
    [self.listArray addObject:model];
    NSURL *nUrl             = [NSURL URLWithString:model.url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nUrl];
    request.userInfo        = @{@"key":model.url};
    request.delegate        = delegate;
    request.downloadProgressDelegate = delegate;
    request.downloadDestinationPath = [FileManager getDownloadDirPathWithFloderModel:model];
    request.temporaryFileDownloadPath =[FileManager getTempDownloadFileWithFloderModel:model];
//    [request setDownloadDestinationPath:[FileManager getDownloadDirPathWithFloderModel:model]];
//    NSLog(@"temp path %@", [FileManager getTempDownloadFileWithFloderModel:model]);
//    [request setTemporaryFileDownloadPath:[FileManager getTempDownloadFileWithFloderModel:model]];
    [request setAllowResumeForFileDownloads:YES];
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

@end