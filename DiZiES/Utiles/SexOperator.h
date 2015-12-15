//
//  SexOperator.h
//  DiZiES
//
//  Created by admin on 15/8/29.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"
#import "Tools.h"
#import "AppDelegate.h"

/**
 * 文件下载的状态
 */
typedef NS_ENUM(NSInteger, DownloadFileState)
{
    DownloadFileStateNone,//文件没有下载
    DownloadFileStateDownloading,//文件正在下载
    DownloadFileStateSuspend,//文件暂停下载
    DownloadFileStateDownloaded,//文件下载完成
    DownloadFileStateFailure,//文件下载失败
};

/**
 * 下载类（单类）
 */
@interface SingleDownloadQueue : NSObject

+ (SingleDownloadQueue *)shareInstance;
/**
 * 下载文件
 * @description 下载文件，将文件配置加入到正在下载的配置列表里 启动下载进程
 */
- (void)downloadFileUrl:(NSString *)fileUrl;
/**
 * 下载文件
 * @description 下载文件，将文件配置加入到正在下载的配置列表里 设置文件的下载状态为 downloading
 */
- (void)downloadFileModel:(FloderDataModel *)dataModel;
/**
 * 暂停下载文件
 * @description 暂停文件下载，将文件配置从下载配置列表中移除，加入到暂停配置文件中，设置文件的下载状态为 suspending
 */
- (void)suspendDownloadFileModel:(FloderDataModel *)dataModel;
/**
 * 取消下载文件
 * @description 取消下载文件，将文件配置从下载配置列表或者暂停配置文件中移除，加入到取消配置文件中，删除下载的文件 设置文件的下载状态为 none
 */
- (void)cancelDownloadFileModel:(FloderDataModel *)dataModel;

@end

@interface SexOperator : NSOperation

- (void)resetData;

@end