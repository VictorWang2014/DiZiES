
//
//  FileManager.m
//  EBS
//
//  Created by 王明权 on 15/5/14.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import "FileManager.h"
#import "CommonDefine.h"

@implementation FileManager

+ (NSString *)getDocumentPath
{
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path                  = [paths firstObject];
    return path;
}

+ (NSString *)getLibraryPath
{
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path                  = [paths firstObject];
    return path;
}

+ (NSString *)getCacheDirPath
{
    NSArray *paths                  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path                  = [paths firstObject];
    return path;
}

+ (NSString *)getTmpDirPath
{
    NSString *tmpDir                = NSTemporaryDirectory();
    return tmpDir;
}

+ (NSString *)getLibraryPathDirWithName:(NSString *)name
{
    NSString *docPath               = [self getDocumentPath];
    NSString *filePath              = [NSString stringWithFormat:@"%@/%@", docPath, name];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
    {
        NSError *error;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSAssert(@"Download Directory create failure %@", error.localizedDescription);
        }
    }
    return filePath;
}

+ (NSString *)getDocumentPathWithName:(NSString *)name
{
    NSString *docPath               = [self getDocumentPath];
    NSString *path                  = [NSString stringWithFormat:@"%@/%@", docPath, name];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (NSString *)getDownloadDirPath
{
    NSString *docPath               = [self getLibraryPath];
    NSString *filePath              = [NSString stringWithFormat:@"%@/DownLoadFile", docPath];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
    {
        NSError *error;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSAssert(@"Download Directory create failure %@", error.localizedDescription);
        }
    }
    return filePath;
}

+ (NSString *)getDownloadCachesDirPath
{
    NSString *docPath               = [self getCacheDirPath];
    NSString *filePath              = [NSString stringWithFormat:@"%@/TempDownLoadFile", docPath];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
    {
        NSError *error;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSAssert(@"Download Directory create failure %@", error.localizedDescription);
        }
    }
    return filePath;
}

+ (NSString *)getDownloadDirPathWithName:(NSString *)name
{
    NSString *docPath               = [self getDownloadDirPath];
    NSString *path                  = [NSString stringWithFormat:@"%@/%@", docPath, name];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (BOOL)fileIsExistAtPath:(NSString *)filePath
{
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getDownloadCachesDirPathWithName:(NSString *)name
{
    NSString *docPath               = [self getDownloadDirPath];
    NSString *path                  = [NSString stringWithFormat:@"%@/%@", docPath, name];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (NSArray *)getAllFilesInDirPath:(NSString *)dirPath
{
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    NSArray *array                  = [fileManager subpathsAtPath:dirPath];
    return array;
}

+ (NSString *)getDownloadDirPathWithFloderModel:(FloderDataModel *)model
{
    NSString *docPath               = [self getDownloadDirPath];
    NSString *path                  = [NSString stringWithFormat:@"%@/%@", docPath, [NSString stringWithFormat:@"%@", model.fileNameStr]];
    NSLog(@"%@", path);
    return path;
}

+ (NSString *)getTempDownloadFilePathWithFloderModel:(FloderDataModel *)model
{
    NSString *docPath               = [self getDownloadCachesDirPath];
    NSString *path                  = [NSString stringWithFormat:@"%@/%@.temp", docPath, [NSString stringWithFormat:@"%@", model.fileNameStr]];
    return path;
}

+ (NSString *)getTempDownloadFileWithFloderModel:(FloderDataModel *)model
{
    NSString *docPath               = [self getDownloadCachesDirPath];
    NSString *path                  = [NSString stringWithFormat:@"%@/%@.temp", docPath, [NSString stringWithFormat:@"%@", model.fileNameStr]];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (NSString *)getResumeDownloadInfoPlistFile
{
    NSString *path                  = [self getDocumentPathWithName:@"FileModel.archive"];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (BOOL)deleteDownloadFileWithFloderModel:(FloderDataModel *)model
{
    NSString *path                  = [self getDownloadDirPathWithFloderModel:model];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        [fileManager removeItemAtPath:path error:nil];
        return YES;
    }
    return NO;
}

+ (NSString *)getBookMarkFile
{
    NSString *path                  = [self getDownloadDirPathWithName:@"bookMark.archive"];
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

+ (void)createFileAtFilePath:(NSString *)filePath
{
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
}

+ (BOOL)createFileDirAtFilePath:(NSString *)fileDirPath
{
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:fileDirPath isDirectory:&isDir] && !isDir)
    {
        NSError *error;
        [fileManager createDirectoryAtPath:fileDirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSAssert(@"Download Directory create failure %@", error.localizedDescription);
        }
        NSLog(@"FileDirPath %@ create success", fileDirPath);
        return YES;
    }
    
    return NO;
}

+ (void)deleteFileAtFilePath:(NSString *)filePath
{
    NSFileManager *fileManager      = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

@end

@implementation FileManager (DownloadFileManger)

+ (NSString *)tempDownloadFilePathWithFileModel:(FloderDataModel *)model
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *tmpDirPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadTmpDir];
    [FileManager createFileDirAtFilePath:tmpDirPath];
    NSString *tmpFilePath = [NSString stringWithFormat:@"%@/%lu_%@", tmpDirPath, (unsigned long)model.url.hash, model.fileNameStr];
    return tmpFilePath;
}

+ (NSString *)downloadFilePathWithFileModel:(FloderDataModel *)model
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *downloadedDir = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadedDir];
    [FileManager createFileDirAtFilePath:downloadedDir];
    NSString *downloadedFilePath = [NSString stringWithFormat:@"%@/%lu_%@", downloadedDir, (unsigned long)model.url.hash, model.fileNameStr];
    return downloadedFilePath;
}

+ (BOOL)deleteSuspendPlistFileModel:(FloderDataModel *)model
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *suspendDownloadingPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerSuspendPlistPath];
    if (![FileManager fileIsExistAtPath:suspendDownloadingPath]) {
        return NO;
    }
    NSMutableArray *suspendArray = [NSKeyedUnarchiver unarchiveObjectWithFile:suspendDownloadingPath];
    if (suspendArray.count == 0 || suspendArray == nil) {
        return NO;
    }
    int i = 0;
    for (; i < suspendArray.count; i++)
    {
        FloderDataModel *data = [suspendArray objectAtIndex:i];
        if ([data.url isEqualToString:model.url]) {
            [suspendArray removeObject:data];
            break;
        }
    }
    if (i == suspendArray.count && i != 0)// delete file not contain  so delete fail
        return NO;
    if (suspendArray.count <= 0) {
        NSLog(@"%@  arrar is nil, can't write into file", NSStringFromSelector(_cmd));
        return NO;
    }
    [NSKeyedArchiver archiveRootObject:suspendArray toFile:suspendDownloadingPath];
    NSLog(@"%@  %d", NSStringFromSelector(_cmd), suspendArray.count);
    return YES;
}

+ (BOOL)deleteDownloadingPlistFileModel:(FloderDataModel *)model
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *downloadingPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadingPlistPath];
    [FileManager createFileAtFilePath:downloadingPath];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:downloadingPath];
    if (array.count == 0 || array == nil) {
        return NO;
    }
    int i = 0;
    for (; i < array.count; i++)
    {
        FloderDataModel *data = [array objectAtIndex:i];
        if ([data.url isEqualToString:model.url]) {
            [array removeObject:data];
            break;
        }
    }
    if (i == array.count && i != 0) {
        return NO;
    }
    if (array.count <= 0) {
        NSLog(@"%@  arrar is nil, can't write into file", NSStringFromSelector(_cmd));
        return NO;
    }
    [NSKeyedArchiver archiveRootObject:array toFile:downloadingPath];
    NSLog(@"%@  %d", NSStringFromSelector(_cmd), array.count);
    return YES;
}

+ (BOOL)addSuspendPlistFileModel:(FloderDataModel *)model
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *suspendDownloadingPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerSuspendPlistPath];
    [FileManager createFileAtFilePath:suspendDownloadingPath];
    NSMutableArray *suspendArray = [NSKeyedUnarchiver unarchiveObjectWithFile:suspendDownloadingPath];
    if (suspendArray.count == 0 || suspendArray == nil) {
        return NO;
    }
    int i = 0;
    for (; i < suspendArray.count; i++)
    {
        FloderDataModel *data = [suspendArray objectAtIndex:i];
        if ([data.url isEqualToString:model.url]) {
            break;
        }
    }
    if (i == suspendArray.count) {
        if (suspendArray.count == 0)
            suspendArray = [NSMutableArray array];
        [suspendArray addObject:model];
        if (suspendArray.count <= 0) {
            NSLog(@"%@  arrar is nil, can't write into file", NSStringFromSelector(_cmd));
            return NO;
        }
        [NSKeyedArchiver archiveRootObject:suspendArray toFile:suspendDownloadingPath];
        NSLog(@"%@  %d", NSStringFromSelector(_cmd), suspendArray.count);
        return YES;
    }
    return NO;
}

+ (BOOL)addDownloadingPlistFileModel:(FloderDataModel *)model
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *downloadingPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadingPlistPath];
    [FileManager createFileAtFilePath:downloadingPath];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:downloadingPath];
    if (array.count == 0 || array == nil) {
        array = [NSMutableArray array];
        [array addObject:model];
        NSLog(@"%@  %d", NSStringFromSelector(_cmd), array.count);
        if (array.count <= 0) {
            NSLog(@"%@  arrar is nil, can't write into file", NSStringFromSelector(_cmd));
            return NO;
        }
        [NSKeyedArchiver archiveRootObject:array toFile:downloadingPath];
    } else {
        int i = 0;
        for (; i < array.count; i++)
        {
            FloderDataModel *data = [array objectAtIndex:i];
            if ([data.url isEqualToString:model.url])
                break;
        }
        if (i == array.count) {// not contain
            if (array.count == 0)
                array = [NSMutableArray array];
            [array addObject:model];
            if (array.count <= 0) {
                NSLog(@"%@  arrar is nil, can't write into file", NSStringFromSelector(_cmd));
                return NO;
            }
            [NSKeyedArchiver archiveRootObject:array toFile:downloadingPath];
            return YES;
        }
        return NO;
    }
    return YES;
}

+ (NSMutableArray *)getDownloadingFileModelOfPlist;
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *downloadingPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadingPlistPath];
    [FileManager createFileAtFilePath:downloadingPath];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:downloadingPath];
    return array;
}

+ (NSMutableArray *)getTempFileModelOfPlist;
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *suspendPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerSuspendPlistPath];
    [FileManager createFileAtFilePath:suspendPath];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:suspendPath];
    return array;
}

+ (void)saveDownloadingFileModel:(FloderDataModel *)model contentData:(NSData *)contentData
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *downloadedDir = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadedDir];
    [FileManager createFileDirAtFilePath:downloadedDir];
    NSString *downloadedFilePath = [NSString stringWithFormat:@"%@/%lu_%@", downloadedDir, (unsigned long)model.url.hash, model.fileNameStr];
    [FileManager createFileAtFilePath:downloadedFilePath];
    [contentData writeToFile:downloadedFilePath atomically:YES];
}

+ (BOOL)deleteTempFileWithFileModel:(FloderDataModel *)model
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *tmpDirPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadTmpDir];
    if ([FileManager createFileDirAtFilePath:tmpDirPath]) {
        return NO;
    }
    NSString *tmpFilePath = [NSString stringWithFormat:@"%@/%lu_%@", tmpDirPath, (unsigned long)model.url.hash, model.fileNameStr];
    if ([FileManager fileIsExistAtPath:tmpFilePath]) {
        [FileManager deleteFileAtFilePath:tmpFilePath];
        return YES;
    }
    return NO;
}

+ (BOOL)deleteDownloadedFileWithFileModel:(FloderDataModel *)model
{
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *downloadedDir = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadedDir];
    [FileManager createFileDirAtFilePath:downloadedDir];
    NSString *downloadedFilePath = [NSString stringWithFormat:@"%@/%lu_%@", downloadedDir, (unsigned long)model.url.hash, model.fileNameStr];
    if ([FileManager fileIsExistAtPath:downloadedFilePath]) {
        [FileManager deleteFileAtFilePath:downloadedFilePath];
        return YES;
    }
    return NO;
}

+ (BOOL)updateDownloadingPlistFileWithFileModel:(FloderDataModel *)model
{
    NSMutableArray *array = [FileManager getDownloadingFileModelOfPlist];
    if (array.count == 0 || array == nil) {
        return NO;
    }
    int i = 0;
    for (; i < array.count; i++) {
        FloderDataModel *data = [array objectAtIndex:i];
        if ([data.url isEqualToString:model.url]) {
            data.tmpSize = model.tmpSize;
            break;
        }
    }
    if (i == array.count) {
        return NO;
    }
    NSString *downloadDir = [FileManager getLibraryPathDirWithName:kDownloadManagerDir];
    NSString *downloadingPath = [NSString stringWithFormat:@"%@/%@", downloadDir, kDownloadManagerDownloadingPlistPath];
    [FileManager createFileAtFilePath:downloadingPath];
    NSLog(@"%@  %d", NSStringFromSelector(_cmd), array.count);
    if (array.count <= 0) {
        NSLog(@"%@  arrar is nil, can't write into file", NSStringFromSelector(_cmd));
        return NO;
    }
    [NSKeyedArchiver archiveRootObject:array toFile:downloadingPath];
    return YES;
}

@end
