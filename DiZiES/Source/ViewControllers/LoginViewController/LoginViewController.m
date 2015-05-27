//
//  LoginViewController.m
//  DiZiES
//
//  Created by admin on 15/5/24.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfoModle.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userNameTextFeild;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextFeild;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)loginButtonClick:(UIButton *)sender
{
    AppUserInfo.isLogin = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
