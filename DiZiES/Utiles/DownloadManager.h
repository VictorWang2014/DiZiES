//
//  DownloadManager.h
//  DiZiES
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeDataModle.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

typedef void(^DownloadManagerSuccess)(id data);

@interface DownloadManager : NSObject

@property (nonatomic, retain) NSMutableDictionary *downloadTasksDic;

@property (nonatomic) int queueCount;

@property (nonatomic, strong) ASINetworkQueue *queue;

+ (DownloadManager *)shareInstance;

- (void)downloadWithUrl:(NSString *)url downloadSuccess:(DownloadManagerSuccess)success;
// 开始下载文件
- (void)downloadFileWithFileModel:(FloderDataModel *)model;
// 开始下载文件 代理通知进度
- (void)downloadFileWithFileModel:(FloderDataModel *)model delegate:(id)delegate;
// 暂停下载文件
- (void)suspendRequestWithFileModel:(FloderDataModel *)model;
// 唤醒文件下载
- (void)resumeRequestWithFileMode:(FloderDataModel *)model;

- (ASIHTTPRequest *)getDownloadRequestWithFileModel:(FloderDataModel *)model;

@end

