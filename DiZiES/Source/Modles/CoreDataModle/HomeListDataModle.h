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

@property (nonatomic, retain) NSString * fatherNode;
@property (nonatomic, retain) NSString * currentNode;
@property (nonatomic, retain) NSNumber * canExpand;
@property (nonatomic, retain) NSNumber * isExpand;
@property (nonatomic, retain) NSString * fileNameStr;
@property (nonatomic) NSInteger index;

@end
