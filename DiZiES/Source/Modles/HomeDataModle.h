//
//  HomeDataModle.h
//  DiZiES
//
//  Created by admin on 15/5/21.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DownloadState)
{
    DownloadStateNone,
    DownloadStateSuspend,
    DownloadStateDownloading,
    DownloadStateDownloadWait,
    DownloadStateDownloaded,
    DownloadStateDownloadError
};

@interface HomeDataModle : NSObject

@property (nonatomic, strong) NSString      *name;

@property (nonatomic, strong) UIImage       *image;

@end


@interface FloderDataModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *fileID;
@property (nonatomic, strong) NSString *fileNameStr;
@property (nonatomic, strong) NSString *fileSize;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *fatherNode;
@property (nonatomic, strong) NSString *currentNode;
@property (nonatomic, strong) NSNumber *canExpand;
@property (nonatomic, strong) NSNumber *isExpand;
@property (nonatomic, strong) NSNumber *isDownloaded;

@property (nonatomic) DownloadState downloadState;

@property (nonatomic) NSInteger index;

@end