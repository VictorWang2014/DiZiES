
//
//  FileManager.m
//  EBS
//
//  Created by 王明权 on 15/5/14.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (NSString *)getDocumentPath
{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    return path;
}

+ (NSString *)getLibraryPath
{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    return path;
}

+ (NSString *)getCacheDirPath
{
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    return path;
}

+ (NSString *)getTmpDirPath
{
    NSString *tmpDir    = NSTemporaryDirectory();
    return tmpDir;
}

+ (NSString *)getDocumentPathWithName:(NSString *)name
{
    NSString *docPath   = [self getDocumentPath];
    NSString *path      = [NSString stringWithFormat:@"%@/%@", docPath, name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    return path;
}

@end
