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

@interface LoginViewController ()<NSURLConnectionDataDelegate>

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
    [self loginRequest];
    AppUserInfo.isLogin = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginRequest
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:LoginUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *string = @"&user=admin&pass=admin";
    [request setHTTPBody:[string dataUsingEncoding:NSASCIIStringEncoding]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"!-------%@", string);
    }];
}

@end
