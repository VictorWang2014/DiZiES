//
//  DownloadManager.h
//  DiZiES
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFNetworking.h"
#import "HomeDataModle.h"

typedef void(^DownloadManagerSuccess)(id data);

@interface DownloadManager : NSObject

@property (nonatomic, retain) NSMutableDictionary *downloadTasksDic;

+ (DownloadManager *)shareInstance;

- (void)downloadWithUrl:(NSString *)url downloadSuccess:(DownloadManagerSuccess)success;
// 开始下载文件
- (void)downloadWithFile:(FloderDataModel *)fileModel downloadSuccess:(DownloadManagerSuccess)success;
// 暂停下载文件
- (void)suspendWithFile:(FloderDataModel *)fileModel;
// 唤醒文件下载
- (void)resumeWithFile:(FloderDataModel *)fileModel;

@end

