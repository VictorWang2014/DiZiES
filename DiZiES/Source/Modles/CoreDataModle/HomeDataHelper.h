//
//  HomeDataHelper.h
//  DiZiES
//
//  Created by admin on 15/5/24.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HomeDataHelperContext  [HomeDataHelper shareInstance]

@class HomeListDataModle;

@interface HomeDataHelper : NSObject

+ (HomeDataHelper *)shareInstance;

- (HomeListDataModle *)newObject;

- (BOOL)save;

- (NSArray *)fetchItemsMatching:(NSString *)searchStr forAttribute:(NSString *)attribute;

@end
