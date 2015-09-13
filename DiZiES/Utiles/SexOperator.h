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

@interface SingleDownloadQueue : NSObject

+ (SingleDownloadQueue *)shareInstance;

- (void)downloadFileUrl:(NSString *)fileUrl;

- (void)downloadFileModel:(FloderDataModel *)dataModel;

- (void)suspendDownloadFileModel:(FloderDataModel *)dataModel;

- (void)cancelDownloadFileModel:(FloderDataModel *)dataModel;

@end

@interface SexOperator : NSOperation

- (void)resetData;

@end