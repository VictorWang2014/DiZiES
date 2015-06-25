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
{
    AFURLSessionManager *_sessionManager;
//    AFHTTPSessionManager *_httpSessionManager;// http请求的时候用
}

@property (nonatomic, retain) AFURLSessionManager *sessionManager;

@end

@implementation DownloadManager

+ (DownloadManager *)shareInstance
{
    static DownloadManager *downloadManager       = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        downloadManager = [[DownloadManager alloc] init];
    });
    return downloadManager;
}

- (id)init//http://x1.zhuti.com/down/2012/11/29-win7/3D-1.jpg
{
    self = [super init];
    if (self)
    {
        self.downloadTasksDic = [NSMutableDictionary dictionary];
        self.sessionManager = [[AFURLSessionManager alloc] init];
        [self _resumeLastDownloading];
    }
    return self;
}
// 恢复之前暂停的下载
- (void)_resumeLastDownloading
{
    
}



- (void)downloadWithUrl:(NSString *)url downloadSuccess:(DownloadManagerSuccess)success
{
    NSURLRequest *request               = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *task      = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *pathUrl                  = [NSURL fileURLWithPath:[FileManager getDocumentPathWithName:[NSString stringWithFormat:@"%@", url]]];
        return pathUrl;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error)
        {
            success(@"failure");
        }
        else
        {
            success(@"success");
        }
    }];
    [task resume];
    [self.downloadTasksDic setObject:task forKey:@"key"];
}

- (void)downloadWithFile:(FloderDataModel *)fileModel downloadSuccess:(DownloadManagerSuccess)success
{
    if (fileModel.url == nil || fileModel.url.length == 0)
        return;
    
    NSURLRequest *request               = [NSURLRequest requestWithURL:[NSURL URLWithString:fileModel.url]];
    NSURLSessionDownloadTask *task      = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *pathUrl                  = [NSURL fileURLWithPath:[FileManager getDownloadDirPathWithFloderModel:fileModel]];
        NSLog(@"download filepath %@", pathUrl);
        return pathUrl;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error)
        {
            success(@"failure");
        }
        else
        {
            success(@"success");
        }
    }];

    [task resume];
    NSString *fileNameKey               = [fileModel.fileNameStr stringByDeletingPathExtension];
    [self.downloadTasksDic setObject:task forKey:fileNameKey];
}

- (void)suspendWithFile:(FloderDataModel *)fileModel
{
    NSString *fileNameKey               = [fileModel.fileNameStr stringByDeletingPathExtension];
    NSURLSessionDownloadTask *task      = [self.downloadTasksDic objectForKey:fileNameKey];
    [task suspend];
}

- (void)resumeWithFile:(FloderDataModel *)fileModel
{
    NSString *fileNameKey               = [fileModel.fileNameStr stringByDeletingPathExtension];
    NSURLSessionDownloadTask *task      = [self.downloadTasksDic objectForKey:fileNameKey];
    [task resume];
}


@end

