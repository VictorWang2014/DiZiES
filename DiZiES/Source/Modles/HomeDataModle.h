//
//  HomeDataModle.h
//  DiZiES
//
//  Created by admin on 15/5/21.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomeDataModle : NSObject

@property (nonatomic, strong) NSString      *name;

@property (nonatomic, strong) UIImage       *image;

@end


@interface FloderDataModel : NSObject

@property (nonatomic, strong) NSString * fatherNode;
@property (nonatomic, strong) NSString * currentNode;
@property (nonatomic, strong) NSNumber * canExpand;
@property (nonatomic, strong) NSNumber * isExpand;
@property (nonatomic, strong) NSString * fileNameStr;

@property (nonatomic) NSInteger index;

@end