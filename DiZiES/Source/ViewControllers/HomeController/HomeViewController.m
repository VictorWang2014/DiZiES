//
//  HomeViewController.m
//  EBS
//
//  Created by 王明权 on 15/5/13.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import "HomeViewController.h"

#import "HomeListTableViewCell.h"

#import "HomeDataModle.h"

#import "Tools.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *listArray;    // 左侧文件列表数据

@end

@implementation HomeViewController


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initSubviews];// 视图初始化
    
    [self _loadData];// 首页数据初始化
}

- (void)_initSubviews
{
    _homeListTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _homeWebView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_homeListTableView(==220)][_homeWebView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_homeListTableView, _homeWebView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_homeListTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_homeListTableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_homeWebView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_homeWebView)]];
    
    [_homeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
}

- (void)_loadData
{
    self.listArray                  = [NSMutableArray array];
    for (int i = 0; i < 30; i++)
    {
        HomeDataModle *modle        = [[HomeDataModle alloc] init];
        modle.name                  = [NSString stringWithFormat:@"文件夹—%d", i];
        [_listArray addObject:modle];
    }
    HomeDataModle *modle        = [[HomeDataModle alloc] init];
    modle.name                  = @"我的文档";
    [_listArray addObject:modle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma marke - UITableViewDataSource UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier         = @"homelisttableviewcell";
    HomeListTableViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:identifier];

    HomeDataModle *modle                = [_listArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text                = modle.name;
    cell.fileImg.image                  = [UIImage imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(40, 40)];
    cell.sepLineImg.image               = [UIImage imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(cell.frame.size.width, 1)];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
