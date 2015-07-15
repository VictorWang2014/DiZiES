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
/**姓名*/
@property (nonatomic, strong) NSString *userName;
/**用户名*/
@property (nonatomic, strong) NSString *userID;
/**密码*/
@property (nonatomic, strong) NSString *password;
/**部门*/
@property (nonatomic, strong) NSString *department;
/**资产号*/
@property (nonatomic, strong) NSString *capital;
/**工号*/
@property (nonatomic, strong) NSString *agentID;
/**是否已经登录*/
@property (nonatomic) BOOL              isLogin;

+ (UserInfoModle *)shareInstance;

@end
