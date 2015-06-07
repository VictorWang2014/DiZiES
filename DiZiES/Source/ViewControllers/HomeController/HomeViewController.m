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
#import "DataRequest.h"
#import "DataResponseParser.h"
#import "CommonDefine.h"
#import "Tools.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView      *homeListTableView;
@property (nonatomic, strong) NSMutableArray            *listArray;    // 左侧本地保存的文件列表
@property (nonatomic, strong) NSMutableArray            *listDataSourceArray;// 左侧文件列表数据

@property (nonatomic, strong) NSMutableArray            *tempArray;

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
    _listDataSourceArray                = [NSMutableArray array];

    _listArray                          = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:nil forAttribute:nil]];
    _listDataSourceArray                = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:@"fatherNode" forAttribute:@"node_0"]];
   
    [_homeListTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tempArray  = [NSMutableArray array];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshHomeListFloder];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"!----temp array%d", self.tempArray.count);
    });
}

#pragma mark - DataRequest
- (void)refreshHomeListFloder
{
    [self requestWithFloderId:@"1" callBack:^(id data) {
        [HomeDataHelperContext deleteObjects];
        for (FloderDataModel *data in self.tempArray) {
            [HomeDataHelperContext addHomeData:data];
        }
        [HomeDataHelperContext save];
        _listArray                          = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:nil forAttribute:nil]];
        _listDataSourceArray                = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:@"fatherNode" forAttribute:@"node_0"]];
        [_homeListTableView reloadData];
    }];
}

- (void)requestWithFloderId:(NSString *)floderId callBack:(CallBack)callBack
{
    NSString *requestID                         = floderId;
    if (floderId.length > 1)
    {
        requestID                               = [floderId substringFromIndex:floderId.length-1];
    }
    [DataRequest requestSyncUrl:[NSString stringWithFormat:@"%@%@/children", FloderUrl, requestID] responseClass:[FlorderResponseParse class] success:^(id data) {
        if ([data isKindOfClass:[FlorderResponseParse class]])
        {
            FlorderResponseParse *florderData   = (FlorderResponseParse *)data;
            if (florderData.flordListArray.count >= 1)
            {
                NSString *fatherNode            = @"";
                if ([floderId isEqualToString:@"1"])
                    fatherNode                  = @"node_0";
                else
                    fatherNode                  = floderId;
//                NSLog(@"!+++++++++++++++");
//                NSLog(@"fathernode %@", fatherNode);
                for (int i = 0; i < florderData.flordListArray.count; i++)
                {
                    FloderDataModel *data   = [florderData.flordListArray objectAtIndex:i];
                    data.fatherNode         = fatherNode;
                    data.currentNode        = [NSString stringWithFormat:@"%@_%@", fatherNode, data.fileID];
                    // 保存本地
                    [self.tempArray addObject:data];
//                    NSLog(@"currentnode %@", data.currentNode);
//                    NSLog(@"filename %@", data.fileNameStr);
                    if ([data.canExpand boolValue])
                    {
                        [self requestWithFloderId:data.currentNode callBack:callBack];
                    }
                }
//                NSLog(@"!===============");
                callBack(data);
            }
        }
    } failure:^(id data) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)arrayWithCurrentNode:(NSString *)currentNode
{
    NSMutableArray *array           = [NSMutableArray array];
    for (HomeListDataModle *data in _listDataSourceArray)
    {
        if ([data.fatherNode rangeOfString:currentNode].location != NSNotFound)
        {
            data.isExpand           = [NSNumber numberWithBool:NO];
            [array addObject:data];
        }
    }
    return array;
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeListTableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:@"homelisttableviewcell"];
    cell.sepLineImg.image           = [UIImage imageWithColor:UIColorWith(207, 207, 207) size:CGSizeMake(cell.EWidth, 1)];
    HomeListDataModle *data         = [_listDataSourceArray objectAtIndex:indexPath.row];
    cell.titleLabel.text            = data.fileNameStr;
    cell.dataLabel.text             = data.date;
    
    int fileSize                    = [data.fileSize floatValue];
    if (fileSize > 0)
    {
        fileSize++;
        NSString *fileS             = [NSString stringWithFormat:@"%dB", fileSize];
        if (fileSize/1024 >= 1) {
            fileSize                = fileSize/1024;
            fileSize++;
            fileS                   = [NSString stringWithFormat:@"%dKB", fileSize];
            if (fileSize/1024 >= 1) {
                fileSize            = fileSize/1024;
                fileSize++;
                fileS               = [NSString stringWithFormat:@"%dMB", fileSize];
            }
        }
        cell.fileSizeLabel.text     = fileS;
    }else
        cell.fileSizeLabel.text     = @"";
    
    NSArray *sepNum                 = [data.currentNode componentsSeparatedByString:@"_"];
    cell.imgViewLeadingConstraint.constant  = 20 + (sepNum.count-2)*40;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _listDataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    HomeListDataModle *data         = [_listDataSourceArray objectAtIndex:indexPath.row];
    if (![data.canExpand boolValue]) {
        // 是文件  需要提示下载或者显示
        return;
    }
    BOOL isExpand                   = [data.isExpand boolValue];
    if (isExpand)
    {// 已经展开  则收回  将isExpand 设置为NO
        data.isExpand               = [NSNumber numberWithBool:NO];
        
        NSArray *array                  = [self arrayWithCurrentNode:data.currentNode];// 收缩展开中的数组
        
        [_listDataSourceArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, array.count)]];
        NSMutableArray *deleteArrays    = [NSMutableArray array];
        for (int i = 0; i < array.count; i++)
            [deleteArrays addObject:[NSIndexPath indexPathForRow:indexPath.row+1+i inSection:indexPath.section]];
        
        [tableView deleteRowsAtIndexPaths:deleteArrays withRowAnimation:UITableViewRowAnimationFade];
    }
    else// 没有展开  则执行展开操作 将isExpand 设置为YES
    {
        data.isExpand               = [NSNumber numberWithBool:YES];
        
        NSArray *array                  = [HomeDataHelperContext fetchItemsMatching:@"fatherNode" forAttribute:data.currentNode];
        [_listDataSourceArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1,[array count])]];
        NSMutableArray *insertArrays    = [NSMutableArray array];
        for (int i = 0; i < array.count; i++)
            [insertArrays addObject:[NSIndexPath indexPathForRow:indexPath.row+1+i inSection:indexPath.section]];
        
        [tableView insertRowsAtIndexPaths:insertArrays withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

@end
#if 0
HomeListDataModle *data0            = [HomeDataHelperContext newObject];
data0.fatherNode                    = @"node";
data0.currentNode                   = @"node_0";
data0.fileNameStr                   = @"迪姿有限公司";
data0.canExpand                     = [NSNumber numberWithBool:YES];
data0.index                         = -1;
data0.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data0];

HomeListDataModle *data1            = [HomeDataHelperContext newObject];
data1.fatherNode                    = @"node_0";
data1.currentNode                   = @"node_0_1";
data1.fileNameStr                   = @"IT部门";
data1.canExpand                     = [NSNumber numberWithBool:YES];
data1.index                         = -1;
data1.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data1];

HomeListDataModle *data2            = [HomeDataHelperContext newObject];
data2.fatherNode                    = @"node_0";
data2.currentNode                   = @"node_0_2";
data2.fileNameStr                   = @"运维";
data2.canExpand                     = [NSNumber numberWithBool:YES];
data2.index                         = -1;
data2.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data2];

HomeListDataModle *data3            = [HomeDataHelperContext newObject];
data3.fatherNode                    = @"node_0";
data3.currentNode                   = @"node_0_3";
data3.fileNameStr                   = @"人事";
data3.canExpand                     = [NSNumber numberWithBool:YES];
data3.index                         = -1;
data3.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data3];

HomeListDataModle *data4            = [HomeDataHelperContext newObject];
data4.fatherNode                    = @"node_0_1";
data4.currentNode                   = @"node_0_1_1";
data4.fileNameStr                   = @"peter组";
data4.canExpand                     = [NSNumber numberWithBool:YES];
data4.index                         = -1;
data4.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data4];

HomeListDataModle *data5            = [HomeDataHelperContext newObject];
data5.fatherNode                    = @"node_0_1";
data5.currentNode                   = @"node_0_1_2";
data5.fileNameStr                   = @"mike组";
data5.canExpand                     = [NSNumber numberWithBool:YES];
data5.index                         = -1;
data5.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data5];

HomeListDataModle *data6            = [HomeDataHelperContext newObject];
data6.fatherNode                    = @"node_0_1";
data6.currentNode                   = @"node_0_1_3";
data6.fileNameStr                   = @"tony组";
data6.canExpand                     = [NSNumber numberWithBool:YES];
data6.index                         = -1;
data6.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data6];

HomeListDataModle *data7            = [HomeDataHelperContext newObject];
data7.fatherNode                    = @"node_0_2";
data7.currentNode                   = @"node_0_2_1";
data7.fileNameStr                   = @"jons组";
data7.canExpand                     = [NSNumber numberWithBool:YES];
data7.index                         = -1;
data7.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data7];

HomeListDataModle *data8            = [HomeDataHelperContext newObject];
data8.fatherNode                    = @"node_0_2";
data8.currentNode                   = @"node_0_2_2";
data8.fileNameStr                   = @"jons组";
data8.canExpand                     = [NSNumber numberWithBool:YES];
data8.index                         = -1;
data8.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data8];

HomeListDataModle *data9            = [HomeDataHelperContext newObject];
data9.fatherNode                    = @"node_0_2";
data9.currentNode                   = @"node_0_2_3";
data9.fileNameStr                   = @"allen组";
data9.canExpand                     = [NSNumber numberWithBool:YES];
data9.index                         = -1;
data9.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data9];

HomeListDataModle *data10           = [HomeDataHelperContext newObject];
data10.fatherNode                   = @"node_0_1_2";
data10.currentNode                  = @"node_0_1_2_1";
data10.fileNameStr                  = @"allen组";
data10.canExpand                    = [NSNumber numberWithBool:YES];
data10.index                        = -1;
data10.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data10];

HomeListDataModle *data11           = [HomeDataHelperContext newObject];
data11.fatherNode                   = @"node_0_1_2";
data11.currentNode                  = @"node_0_1_2_2";
data11.fileNameStr                  = @"allen组";
data11.canExpand                    = [NSNumber numberWithBool:YES];
data11.index                        = -1;
data11.isExpand                      = [NSNumber numberWithBool:NO];
[_listArray addObject:data11];
[HomeDataHelperContext save];
#endif

