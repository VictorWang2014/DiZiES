//
//  DownloadManager.h
//  DiZiES
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@class FileModel;

@interface DownloadManager : NSObject

+ (DownloadManager *)shareInstance;

@property (nonatomic, retain) NSMutableDictionary *downloadTasksDic;

- (void)downloadWithUrl:(NSString *)url;

- (void)downloadWithFile:(FileModel *)fileModel;

@end


@interface FileModel : NSObject

@property (nonatomic, strong) NSString *filename;

@property (nonatomic, strong) NSString *fileSize;

@property (nonatomic, strong) NSString *url;

@end