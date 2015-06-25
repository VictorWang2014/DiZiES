
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
    NSString *path                  = [NSString stringWithFormat:@"%@/%@", docPath, [NSString stringWithFormat:@"%d_%@", [[NSString stringWithFormat:@"%@/%@/content", ContentUrl, model.fileID] hash], model.fileNameStr]];
    return path;
}

@end
