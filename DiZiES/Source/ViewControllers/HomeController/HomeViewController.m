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
#import "HomeListDataModle.h"
#import "HomeDataHelper.h"

#import "Tools.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView      *homeListTableView;
@property (nonatomic, strong) NSMutableArray            *listArray;    // 左侧本地保存的文件列表
@property (nonatomic, strong) NSMutableArray            *listDataArray;// 左侧文件列表数据

@end

@implementation HomeViewController


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initView];// 视图初始化
    
    [self _loadData];// 首页数据初始化
}

- (void)_initView
{
    
}

- (void)_loadData
{
    _listArray                          = [NSMutableArray array];
    _listDataArray                      = [NSMutableArray array];
    
    HomeListDataModle *data0            = [HomeDataHelperContext newObject];
    data0.fatherNode                    = @"node_";
    data0.currentNode                   = @"node_0";
    data0.fileNameStr                   = @"迪姿有限公司";
    data0.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data0];
    
    HomeListDataModle *data1            = [HomeDataHelperContext newObject];
    data1.fatherNode                    = @"node_0";
    data1.currentNode                   = @"node_0_1";
    data1.fileNameStr                   = @"IT部门";
    data1.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data1];
    
    HomeListDataModle *data2            = [HomeDataHelperContext newObject];
    data2.fatherNode                    = @"node_0";
    data2.currentNode                   = @"node_0_2";
    data2.fileNameStr                   = @"运维";
    data2.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data2];
    
    HomeListDataModle *data3            = [HomeDataHelperContext newObject];
    data3.fatherNode                    = @"node_0";
    data3.currentNode                   = @"node_0_3";
    data3.fileNameStr                   = @"人事";
    data3.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data3];
    
    HomeListDataModle *data4            = [HomeDataHelperContext newObject];
    data4.fatherNode                    = @"node_0_1";
    data4.currentNode                   = @"node_0_1_1";
    data4.fileNameStr                   = @"peter组";
    data4.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data4];
    
    HomeListDataModle *data5            = [HomeDataHelperContext newObject];
    data5.fatherNode                    = @"node_0_1";
    data5.currentNode                   = @"node_0_1_2";
    data5.fileNameStr                   = @"mike组";
    data5.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data5];
    
    HomeListDataModle *data6            = [HomeDataHelperContext newObject];
    data6.fatherNode                    = @"node_0_1";
    data6.currentNode                   = @"node_0_1_3";
    data6.fileNameStr                   = @"tony组";
    data6.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data6];
    
    HomeListDataModle *data7            = [HomeDataHelperContext newObject];
    data7.fatherNode                    = @"node_0_2";
    data7.currentNode                   = @"node_0_2_1";
    data7.fileNameStr                   = @"jons组";
    data7.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data7];
    
    HomeListDataModle *data8            = [HomeDataHelperContext newObject];
    data8.fatherNode                    = @"node_0_2";
    data8.currentNode                   = @"node_0_2_2";
    data8.fileNameStr                   = @"jons组";
    data8.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data8];
    
    HomeListDataModle *data9            = [HomeDataHelperContext newObject];
    data9.fatherNode                    = @"node_0_2";
    data9.currentNode                   = @"node_0_2_3";
    data9.fileNameStr                   = @"allen组";
    data9.canExpand                     = [NSNumber numberWithBool:YES];
    [_listArray addObject:data9];
    
    HomeListDataModle *data10           = [HomeDataHelperContext newObject];
    data10.fatherNode                   = @"node_0_1_2";
    data10.currentNode                  = @"node_0_1_2_1";
    data10.fileNameStr                  = @"allen组";
    data10.canExpand                    = [NSNumber numberWithBool:YES];
    [_listArray addObject:data10];
    
    HomeListDataModle *data11           = [HomeDataHelperContext newObject];
    data11.fatherNode                   = @"node_0_1_2";
    data11.currentNode                  = @"node_0_1_2_2";
    data11.fileNameStr                  = @"allen组";
    data11.canExpand                    = [NSNumber numberWithBool:YES];
    [_listArray addObject:data11];
    [HomeDataHelperContext save];
    
    [HomeDataHelperContext fetchItemsMatching:@"fatherNode" forAttribute:@"node_0"];
    [HomeDataHelperContext save];
}

- (NSArray *)arrayWithFatherNode:(NSString *)fatherNode
{
    return nil;
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

#pragma mark - UITableViewDataSource UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeListTableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"homelisttableviewcell"];
    cell.sepLineImg.image           = [UIImage imageWithColor:UIColorWith(207, 207, 207) size:CGSizeMake(cell.EWidth, 1)];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



@end
