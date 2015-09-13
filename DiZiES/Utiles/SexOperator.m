//
//  SexOperator.m
//  DiZiES
//
//  Created by admin on 15/8/29.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "SexOperator.h"


typedef NS_ENUM(NSInteger, DownloadQueueState)
{
    DownloadQueueStateNone,
    DownloadQueueStateDownloading,
    DownloadQueueStateDownloaded,
    DownloadQueueStateSusPend
};

@interface SingleDownloadQueue ()
{
    NSOperationQueue *_queue;
    SexOperator *_operation;
}

@end

@implementation SingleDownloadQueue

+ (SingleDownloadQueue *)shareInstance
{
    static SingleDownloadQueue *queue = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        queue = [[SingleDownloadQueue alloc] init];
    });
    return queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operation = [[SexOperator alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        [_queue addOperation:_operation];
    }
    return self;
}

- (void)downloadFileUrl:(NSString *)fileUrl
{
    
}

- (void)downloadFileModel:(FloderDataModel *)dataModel
{
    [gLock lock];
    NSString *sDownloadPath = [FileManager downloadFilePathWithFileModel:dataModel];
    if ([FileManager fileIsExistAtPath:sDownloadPath]) {
        NSLog(@"! 文件已经下载");
        [gLock unlock];
        return;
    }
    
    [FileManager deleteSuspendPlistFileModel:dataModel];
    if ([FileManager addDownloadingPlistFileModel:dataModel]) {
        // add success
        NSLog(@"= 添加到下载队列中成功");
        [gLock unlock];
        return;
    }
    [gLock unlock];
    NSLog(@"= 添加到下载队列中失败");
    // add failure
}

- (void)suspendDownloadFileModel:(FloderDataModel *)dataModel
{
    [gLock lock];
    [FileManager deleteDownloadingPlistFileModel:dataModel];
    if ([FileManager deleteSuspendPlistFileModel:dataModel]) {
        // suspend succes
        NSLog(@"= 暂停正在下载项成功");
        [gLock unlock];
        return;
    }
    // suspend failure
    [gLock unlock];
    NSLog(@"= 暂停正在下载项失败");
}

// 取消下载
- (void)cancelDownloadFileModel:(FloderDataModel *)dataModel
{
    [gLock lock];
    [FileManager deleteSuspendPlistFileModel:dataModel];
    // 先判断是否是正在下载  如果是正在下载  先取消下载  在删除  否则直接删除
    NSMutableArray *array = [FileManager getDownloadingFileModelOfPlist];
    if (array.count > 0) {
        FloderDataModel *data = [array objectAtIndex:0];
        if ([data.url isEqualToString:dataModel.url]) {
            [_operation resetData];
        }
    }
    [FileManager deleteDownloadingPlistFileModel:dataModel];
    // 删除文件
    [FileManager deleteTempFileWithFileModel:dataModel];
    [gLock unlock];
    NSLog(@"= 取消下载成功");
}

@end

@interface SexOperator ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic) DownloadQueueState state;
@property (nonatomic, strong) FloderDataModel *currentDataModel;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSURLConnection *currentConnection;

@end

@implementation SexOperator

- (instancetype)init
{
    self = [super init];
    if (self) {
        _state = DownloadQueueStateNone;
        self.receiveData = [NSMutableData data];
    }
    return self;
}
// 下载之前先判断本次下载是否为  第一次下载   或者是 断点下载       需要区别下载
- (void)downloadWithDataModel:(FloderDataModel *)dataModel//  判断用哪个一方法下载
{
    _state = DownloadQueueStateDownloading;
    _currentDataModel = dataModel;
    NSString *tmpFilePath = [FileManager tempDownloadFilePathWithFileModel:_currentDataModel];
    NSLog(@"tmp file %@  filepath %@", tmpFilePath, dataModel.fileNameStr);
    if ([FileManager fileIsExistAtPath:tmpFilePath]) {
        NSLog(@"== 开始下载  为暂停后继续下载");
        [self continueRequestWithDataModel:dataModel];
    } else {
        NSLog(@"== 开始下载  新文件下载");
        [self startRequestWithDataModel:dataModel];
    }
}

- (void)startRequestWithDataModel:(FloderDataModel *)dataModel
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:dataModel.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.];
    self.currentConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [_currentConnection start];
}

- (void)continueRequestWithDataModel:(FloderDataModel *)dataModel
{
    [gLock lock];
    NSString *tmpFilePath = [FileManager tempDownloadFilePathWithFileModel:_currentDataModel];
    NSData *tmpData = [NSData dataWithContentsOfFile:tmpFilePath];
    [gLock unlock];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:dataModel.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.];
    [request setValue:[NSString stringWithFormat:@"bytes=%lu-", (unsigned long)tmpData.length] forHTTPHeaderField:@"range"];
    self.currentConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_currentConnection start];
}

- (void)resetData
{
    NSLog(@"++++++reset download state");
    self.state = DownloadQueueStateNone;
    _currentDataModel = nil;
    _currentConnection = nil;
    _receiveData = nil;
    _receiveData = [NSMutableData data];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"=== 下载。。。接受到服务器响应");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 将文件保存到tmp file   先查看tmp file是否存在，  存在或不存在
    if (!_currentDataModel) {
        NSLog(@"=== === _currentDataModel 为 nil");
        NSAssert(!_currentDataModel, @"download operation currentDataModel is nil");
    }
    [gLock lock];
    NSString *tmpFilePath = [FileManager tempDownloadFilePathWithFileModel:_currentDataModel];
    if ([FileManager fileIsExistAtPath:tmpFilePath]) {
        // 已经有tmp file
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:tmpFilePath];
        [handle seekToFileOffset:_currentDataModel.tmpSize];
        [handle writeData:data];
        [_receiveData appendData:data];
        _currentDataModel.tmpSize = _receiveData.length;
        NSLog(@"==== %@ 下载中", _currentDataModel.fileNameStr);
    } else {
        // 重新下载
        [FileManager createFileAtFilePath:tmpFilePath];
        [_receiveData appendData:data];
        _currentDataModel.tmpSize = _receiveData.length;
        [_receiveData writeToFile:tmpFilePath atomically:YES];
    }
    NSLog(@"===%@==%lu", _currentDataModel.fileNameStr, (unsigned long)_receiveData.length);
    if ([FileManager updateDownloadingPlistFileWithFileModel:_currentDataModel]) {
        NSLog(@"==== 下载中 更新临时存储 plist 文件成功");
        [gLock unlock];
        return;
    }
    [gLock unlock];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"===== 下载完成 写入下载的文件夹中");
    [gLock lock];
    // 下载成功  将文件保存到已下载文件夹中   删除tmp file
    NSString *tmpFilePath = [FileManager tempDownloadFilePathWithFileModel:_currentDataModel];
    NSData *finallyData = [NSData dataWithContentsOfFile:tmpFilePath];
    [FileManager saveDownloadingFileModel:_currentDataModel contentData:finallyData];
    [FileManager deleteFileAtFilePath:tmpFilePath];
    // 删除 下载plist中的队列项
    if ([FileManager deleteDownloadingPlistFileModel:_currentDataModel]) {
        NSLog(@"===== 下载完成 删除临时存储的 plist 文件成功");
        [self resetData];
        [gLock unlock];
        return;
    }
    [self resetData];
    [gLock unlock];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connect error: %@", error.description);
    NSLog(@"====== 下载失败");
    [gLock lock];
    [FileManager addSuspendPlistFileModel:_currentDataModel];
    [FileManager deleteDownloadingPlistFileModel:_currentDataModel];
    [gLock unlock];
    [self resetData];
}

- (void)main
{
    while (1)
    {
        if (_state == DownloadQueueStateNone) {
            [gLock lock];
            NSMutableArray *downloadArray = [FileManager getDownloadingFileModelOfPlist];
            if (downloadArray.count > 0) {
                [self downloadWithDataModel:downloadArray[0]];
            }
            [gLock unlock];
        } else if (_state == DownloadQueueStateDownloaded) {
            
        } else if (_state == DownloadQueueStateDownloading) {
            
        } else if (_state == DownloadQueueStateSusPend) {
            
        }
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
        sleep(1);
    }
}

@end



