//
//  LoginViewController.m
//  DiZiES
//
//  Created by admin on 15/5/24.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfoModle.h"
#import "CommonDefine.h"
#import "DataResponseParser.h"
#import "DataRequest.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userNameTextFeild;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextFeild;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userNameTextFeild.delegate             = self;
    _passwordTextFeild.delegate             = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_userNameTextFeild becomeFirstResponder];
}

- (IBAction)loginButtonClick:(UIButton *)sender
{
    if (_userNameTextFeild.text.length <= 0)
    {
        UIAlertView *alertView              = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else if (_passwordTextFeild.text.length <= 0)
    {
        UIAlertView *alertView              = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [self loginRequest];
}

- (void)loginRequest
{
    NSString *queryString                   = [NSString stringWithFormat:@"&user=%@&pass=%@", _userNameTextFeild.text, _passwordTextFeild.text];
    [DataRequest requestSyncUrl:LoginUrl queryString:queryString responseClass:[LoginResponseParse class] success:^(id data) {
        NSString *alertString;
        if (![data isKindOfClass:[LoginResponseParse class]])
        {
            alertString                     = @"登陆出错";
        }
        else
        {
            LoginResponseParse *da              = (LoginResponseParse *)data;
            if (da.success == 0)
            {
                AppUserInfo.userName            = _userNameTextFeild.text;
                AppUserInfo.password            = _passwordTextFeild.text;
                AppUserInfo.isLogin             = YES;
                UIAlertView *alertView              = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户登录成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertView dismissWithClickedButtonIndex:0 animated:NO];
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }else
            {
                UIAlertView *alertView              = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户登录失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    } failure:^(id data) {
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _userNameTextFeild) {
        [_passwordTextFeild becomeFirstResponder];
    }else if (textField == _passwordTextFeild)
    {
        [textField resignFirstResponder];
    }
}

@end
