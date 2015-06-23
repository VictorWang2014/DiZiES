//
//  HomeListDataModle.h
//  DiZiES
//
//  Created by admin on 15/5/24.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HomeListDataModle : NSManagedObject

@property (nonatomic, retain) NSString *fileNameStr;
@property (nonatomic, retain) NSString *fileType;
@property (nonatomic, retain) NSString *fileSize;
@property (nonatomic, retain) NSString *fileID;
@property (nonatomic, retain) NSString *date;

@property (nonatomic, retain) NSString *fatherNode;
@property (nonatomic, retain) NSString *currentNode;
@property (nonatomic, retain) NSNumber *canExpand;
@property (nonatomic, retain) NSNumber *isExpand;
@property (nonatomic, strong) NSNumber *isDownloaded;
@property (nonatomic, strong) NSNumber *isBookmarked;

@property (nonatomic) NSInteger index;

@end
