//
//  FileManager.h
//  EBS
//
//  Created by 王明权 on 15/5/14.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (NSString *)getDocumentPath;

+ (NSString *)getLibraryPath;

+ (NSString *)getCacheDirPath;

+ (NSString *)getTmpDirPath;

+ (NSString *)getDocumentPathWithName:(NSString *)name;

+ (NSString *)getDownloadDirPath;

+ (NSString *)getDownloadDirPathWithName:(NSString *)name;

+ (NSString *)getDownloadCachesDirPathWithName:(NSString *)name;

+ (BOOL)fileIsExistAtPath:(NSString *)filePath;

+ (NSArray *)getAllFilesInDirPath:(NSString *)dirPath;

//+ (NSString *)getStoreFilePath;

@end
