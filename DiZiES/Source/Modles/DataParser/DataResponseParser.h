//
//  DataResponseParser.h
//  DiZiES
//
//  Created by admin on 15/5/29.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModle.h"

@interface DataResponseParser : NSObject

@end


@interface LoginResponseParse : NSObject

@property (nonatomic) int success;

@property (nonatomic, retain) UserInfoModle *userInfo;

@end