//
//  UserInfoModle.m
//  DiZiES
//
//  Created by admin on 15/5/24.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "UserInfoModle.h"
#import "CommonDefine.h"

#define KEY_UserName    @"username"
#define KEY_Department  @"department"
#define KEY_Captical    @"captical"
#define KEY_AgentID     @"agentid"
#define KEY_IsLogin     @"islogin"


@interface UserInfoModle ()
{
    NSMutableDictionary *_userInforDic;
}

@property (nonatomic, strong) NSMutableDictionary   *userInforDic;

@end

@implementation UserInfoModle

+ (UserInfoModle *)shareInstance
{
    static UserInfoModle *userInfoModle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userInfoModle   = [[UserInfoModle alloc] init];
        [userInfoModle userInforDic];
    });
    return userInfoModle;
}

- (NSMutableDictionary *)userInforDic
{
    if (_userInforDic == nil)
    {
        _userInforDic           = [NSMutableDictionary dictionaryWithContentsOfFile:UserInfoPath];
        if (_userInforDic == nil) {
            _userInforDic       = [NSMutableDictionary dictionary];
        }
    }
    return _userInforDic;
}

- (void)setUserInforDic:(NSMutableDictionary *)userInforDic
{
    _userInforDic               = userInforDic;
}

- (void)setUserName:(NSString *)userName
{
    [_userInforDic setObject:userName forKey:KEY_UserName];
}

- (NSString *)userName
{
    return [_userInforDic objectForKey:KEY_UserName];
}

- (void)setDepartment:(NSString *)department
{
    [_userInforDic setObject:department forKey:KEY_Department];
}

- (NSString *)department
{
    return [_userInforDic objectForKey:KEY_Department];
}

- (void)setCapital:(NSString *)capital
{
    [_userInforDic setObject:capital forKey:KEY_Captical];
}

- (NSString *)capital
{
    return [_userInforDic objectForKey:KEY_Captical];
}

- (void)setAgentID:(NSString *)agentID
{
    [_userInforDic setObject:agentID forKey:KEY_AgentID];
}

- (NSString *)agentID
{
    return [_userInforDic objectForKey:KEY_AgentID];
}

- (void)setIsLogin:(BOOL)isLogin
{
    [_userInforDic setObject:[NSNumber numberWithBool:isLogin] forKey:KEY_IsLogin];
}

- (BOOL)isLogin
{
    return [[_userInforDic objectForKey:KEY_IsLogin] boolValue];
}

@end
