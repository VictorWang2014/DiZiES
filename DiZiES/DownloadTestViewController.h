//
//  DownloadTestViewController.h
//  DiZiES
//
//  Created by admin on 15/6/27.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDataModle.h"

@interface DownloadTestViewController : UIViewController

@end


@interface Downloader : NSObject

+ (Downloader *)shareInstance;

- (void)downloadFileWithFileModel:(FloderDataModel *)model;

@end