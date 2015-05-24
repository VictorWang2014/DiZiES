//
//  UserInfoModle.h
//  DiZiES
//
//  Created by admin on 15/5/24.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppUserInfo     [UserInfoModle shareInstance]

@interface UserInfoModle : NSObject

+ (UserInfoModle *)shareInstance;

@end
