//
//  UserInfoModle.m
//  DiZiES
//
//  Created by admin on 15/5/24.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "UserInfoModle.h"

@implementation UserInfoModle

+ (UserInfoModle *)shareInstance
{
    static UserInfoModle *userInfoModle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userInfoModle   = [[UserInfoModle alloc] init];
    });
    return userInfoModle;
}

@end
