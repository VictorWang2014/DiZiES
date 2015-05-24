//
//  MainDataModle.h
//  DiZiES
//
//  Created by admin on 15/5/23.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainDataModle : NSObject

@property (nonatomic, strong) NSString      *imageNameStr;
@property (nonatomic, strong) NSString      *titleStr;
@property (nonatomic, strong) NSString      *selectImageNaemStr;

@end

@interface PersonDataModle : NSObject

@property (nonatomic, strong) NSString      *nameStr;
@property (nonatomic, strong) NSString      *imageNameStr;

@end
