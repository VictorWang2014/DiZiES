//
//  FileManager.h
//  EBS
//
//  Created by 王明权 on 15/5/14.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeDataModle.h"

#define kDownloadManagerDir @"VictorWangDir"
#define kDownloadManagerDownloadTmpDir @"DownloadTmpDir"
#define kDownloadManagerDownloadedDir @"DownloadedDir"
#define kDownloadManagerSuspendPlistPath @"suspendDownloading.archiver"
#define kDownloadManagerDownloadingPlistPath @"downloading.archiver"


@interface FileManager : NSObject

+ (NSString *)getDocumentPath;

+ (NSString *)getLibraryPath;

+ (NSString *)getCacheDirPath;

+ (NSString *)getTmpDirPath;

+ (NSString *)getLibraryPathDirWithName:(NSString *)name;

+ (NSString *)getDocumentPathWithName:(NSString *)name;

+ (NSString *)getDownloadDirPath;

+ (NSString *)getDownloadDirPathWithName:(NSString *)name;

+ (NSString *)getDownloadCachesDirPathWithName:(NSString *)name;

+ (BOOL)fileIsExistAtPath:(NSString *)filePath;

+ (NSArray *)getAllFilesInDirPath:(NSString *)dirPath;

+ (NSString *)getDownloadDirPathWithFloderModel:(FloderDataModel *)model;

+ (NSString *)getTempDownloadFilePathWithFloderModel:(FloderDataModel *)model;

+ (NSString *)getTempDownloadFileWithFloderModel:(FloderDataModel *)model;

+ (NSString *)getResumeDownloadInfoPlistFile;

+ (BOOL)deleteDownloadFileWithFloderModel:(FloderDataModel *)model;

+ (NSString *)getBookMarkFile;

+ (void)createFileAtFilePath:(NSString *)filePath;

+ (BOOL)createFileDirAtFilePath:(NSString *)fileDirPath;

+ (void)deleteFileAtFilePath:(NSString *)filePath;

@end



@interface FileManager (DownloadFileManger)
// 下载文件，下载中临时存放的路径
+ (NSString *)tempDownloadFilePathWithFileModel:(FloderDataModel *)model;
// 下载文件，下载完成保存的路径
+ (NSString *)downloadFilePathWithFileModel:(FloderDataModel *)model;
// 删除暂停文件列表
+ (BOOL)deleteSuspendPlistFileModel:(FloderDataModel *)model;

+ (BOOL)deleteDownloadingPlistFileModel:(FloderDataModel *)model;
//
+ (BOOL)addSuspendPlistFileModel:(FloderDataModel *)model;

+ (BOOL)addDownloadingPlistFileModel:(FloderDataModel *)model;

+ (NSMutableArray *)getDownloadingFileModelOfPlist;

+ (NSMutableArray *)getTempFileModelOfPlist;

+ (void)saveDownloadingFileModel:(FloderDataModel *)model contentData:(NSData *)contentData;

+ (BOOL)deleteTempFileWithFileModel:(FloderDataModel *)model;

+ (BOOL)deleteDownloadedFileWithFileModel:(FloderDataModel *)model;

+ (BOOL)updateDownloadingPlistFileWithFileModel:(FloderDataModel *)model;

@end






