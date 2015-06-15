//
//  DownloadManager.h
//  DiZiES
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface DownloadManager : NSObject

+ (DownloadManager *)shareInstance;

- (void)downloadWithUrl:(NSString *)url;

@end
