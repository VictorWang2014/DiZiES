//
//  EBSMainViewController.m
//  DiZiES
//
//  Created by admin on 15/5/23.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "EBSMainViewController.h"
#import "EBSTabBarViewController.h"
#import "LoginViewController.h"

#import "MainTableViewCell.h"

#import "MainDataModle.h"
#import "UserInfoModle.h"
#import "DataRequest.h"
#import "DataResponseParser.h"
#import "DataRequestPackage.h"
#import "CommonDefine.h"
#import "Tools.h"

#import "TestViewController.h"

@interface EBSMainViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    int                 _selectRow;
    BOOL                _needReLoad;
}

@property (nonatomic, strong) IBOutlet UITableView      *tabTableView;
@property (nonatomic, strong) NSMutableArray            *tabListArray;
@property (nonatomic, strong) EBSTabBarViewController   *tabbarViewController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containViewConstraint;

@end

@implementation EBSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _needReLoad                     = NO;
    [self _loadData];
}

- (void)_loadData// 数据加载
{
    _selectRow                      = 1;
    _tabListArray                   = [NSMutableArray array];
    
    NSLog(@"!---%@", AppUserInfo.userName);
    PersonDataModle *personData     = [[PersonDataModle alloc] init];
    personData.nameStr              = AppUserInfo.userName;
    personData.imageNameStr         = @"default_userPortrait.png";
    [_tabListArray addObject:personData];
    
    MainDataModle *data1            = [[MainDataModle alloc] init];
    data1.titleStr                  = @"文档";
    data1.imageNameStr              = @"lefttab_1.png";
    data1.selectImageNaemStr        = @"lefttab_select_1.png";
    [_tabListArray addObject:data1];

    MainDataModle *data2            = [[MainDataModle alloc] init];
    data2.titleStr                  = @"下载";
    data2.imageNameStr              = @"lefttab_2.png";
    data2.selectImageNaemStr        = @"lefttab_select_2.png";
    [_tabListArray addObject:data2];
    
    MainDataModle *data3            = [[MainDataModle alloc] init];
    data3.titleStr                  = @"收藏";
    data3.imageNameStr              = @"lefttab_3.png";
    data3.selectImageNaemStr        = @"lefttab_select_3.png";
    [_tabListArray addObject:data3];

    MainDataModle *data4            = [[MainDataModle alloc] init];
    data4.titleStr                  = @"设置";
    data4.imageNameStr              = @"lefttab_2.png";
    data4.selectImageNaemStr        = @"lefttab_select_2.png";
    [_tabListArray addObject:data4];

    [_tabTableView reloadData];
}



- (void)viewWillAppear:(BOOL)animated
{
    if (AppUserInfo.isLogin == YES)
    {
        NSString *queryString                   = [NSString stringWithFormat:@"&user=%@&pass=%@", AppUserInfo.userName, AppUserInfo.password];
        [DataRequest requestAsyncUrl:LoginUrl queryString:queryString responseClass:[LoginResponseParse class] success:^(id data) {
        } failure:^(id data) {
            
        }];
    }

    [super viewWillAppear:animated];
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        _containViewConstraint.constant = 0;
    else
        _containViewConstraint.constant = -122;
    if (_needReLoad) {
        [self _loadData];
        _needReLoad                 = NO;
    }
    // 判断是否需要弹出登录页面
    if (AppUserInfo.isLogin == NO)
    {
        _needReLoad = YES;
        LoginViewController *vc     = [self.storyboard instantiateViewControllerWithIdentifier:@"loginviewcontroller"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        return;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EBSTabBarViewController *tabbar     = segue.destinationViewController;
    if ([tabbar isKindOfClass:[EBSTabBarViewController class]])
        self.tabbarViewController       = tabbar;
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        MainPersonTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:@"mainpersontableviewcell"];        
        PersonDataModle *data               = [_tabListArray objectAtIndex:0];
        cell.titleLabel.text                = data.nameStr;
        cell.imgeView.ECornerRadius         = 5;
        cell.imgeView.image                 = [UIImage imageNamed:data.imageNameStr];
        cell.backgroundColor                = UIColorWith(39, 39, 39);
        return cell;
    }
    else
    {
        MainTableViewCell *cell             = [tableView dequeueReusableCellWithIdentifier:@"maintableviewcell"];
        UIView *selectView                  = [[UIView alloc] init];
        selectView.backgroundColor          = [UIColor clearColor];
        cell.selectedBackgroundView         = selectView;
        
        MainDataModle *data                 = [_tabListArray objectAtIndex:indexPath.row];
        if (indexPath.row == _selectRow)
            [cell setCellSelect:YES data:data];
        else
            [cell setCellSelect:NO data:data];
        cell.backgroundColor                = UIColorWith(39, 39, 39);
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tabListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 80;
    else
        return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectRow = indexPath.row;
    [tableView reloadData];
    
    if (indexPath.row == 1) {
        [_tabbarViewController setSelectedIndex:0];
    }else if (indexPath.row == 2) {
        [_tabbarViewController setSelectedIndex:1];
    }else if (indexPath.row == 3) {
        [_tabbarViewController setSelectedIndex:2];
    }else if (indexPath.row == 4) {
        [_tabbarViewController setSelectedIndex:3];
    }else if (indexPath.row == 5) {
        TestViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"testviewcontroller"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return NO;
    }
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        _containViewConstraint.constant = 0;
    else
        _containViewConstraint.constant = -125;
}

- (IBAction)userRowSelect:(UIButton *)sender
{
//    NSLog(@"!------row select");
}

@end

