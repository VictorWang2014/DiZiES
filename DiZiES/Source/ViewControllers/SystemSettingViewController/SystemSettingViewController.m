//
//  SystemSettingViewController.m
//  DiZiES
//
//  Created by wangmingquan on 12/7/15.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "Tools.h"
#import "UserInfoModle.h"
#import "LoginViewController.h"
#import "CommonDefine.h"
#import "EBSMainViewController.h"

@interface SystemSettingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identifier = @"identifier0";
        UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text             = [NSString stringWithFormat:@"用户名: %@",AppUserInfo.userName];
        return cell;
    }else if (indexPath.row == 1) {
        static NSString *identifier = @"identifier1";
        UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text             = [NSString stringWithFormat:@"部门: %@",AppUserInfo.department];
        return cell;
    }else if (indexPath.row == 2) {
        static NSString *identifier = @"identifier2";
        UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text             = [NSString stringWithFormat:@"资产号: %@",AppUserInfo.capital];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        static NSString *identifier = @"identifier3";
        UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text             = @"退出登录";
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3)
    {
        NSFileManager *fileManager  = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:UserInfoPath error:nil];
        EBSMainViewController *vc   = [self.storyboard instantiateViewControllerWithIdentifier:@"mainviewcontroller"];
        LoginViewController *logvc     = [self.storyboard instantiateViewControllerWithIdentifier:@"loginviewcontroller"];
        [vc.navigationController presentViewController:logvc animated:YES completion:nil];
    }
}


@end
