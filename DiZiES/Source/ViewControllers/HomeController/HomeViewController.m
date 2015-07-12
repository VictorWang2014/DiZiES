//
//  HomeViewController.m
//  EBS
//
//  Created by 王明权 on 15/5/13.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeListTableViewCell.h"
#import "ReaderViewController.h"

#import "MBProgressHUD.h"
#import "CommonDefine.h"
#import "Tools.h"

#import "DataRequest.h"
#import "DataResponseParser.h"
#import "HomeDataModle.h"
#import "HomeListDataModle.h"
#import "HomeDataHelper.h"
#import "DownloadManager.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, ReaderViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView      *homeListTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshHomeListButton;
@property (nonatomic, strong) NSMutableArray            *listArray;    // 左侧本地保存的文件列表
@property (nonatomic, strong) NSMutableArray            *listDataSourceArray;// 左侧文件列表数据

@property (nonatomic, strong) NSMutableArray            *tempArray;

@property (nonatomic, strong) NSMutableArray            *nodeArray;

@property (nonatomic, strong) MBProgressHUD             *hud;

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
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
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
}

- (void)_loadData
{
    self.nodeArray                      = [NSMutableArray array];
    _listArray                          = [NSMutableArray array];
    _listDataSourceArray                = [NSMutableArray array];

    _listArray                          = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:nil forAttribute:nil]];
    _listDataSourceArray                = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:@"fatherNode" forAttribute:@"node_0"]];
   
    [_homeListTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated//http://videodbcdn.gw.com.cn/tv/20150615jsldb1.mp4 http://x1.zhuti.com/down/2012/11/29-win7/3D-1.jpg
{
    [super viewWillAppear:animated];
//    FileModel *file = [[FileModel alloc] init];
//    file.filename = @"ceshi.mp4";
//    file.url = @"http://videodbcdn.gw.com.cn/tv/20150615jsldb1.mp4";
//    [[DownloadManager shareInstance] downloadWithFile:file];
//    
//    NSURLSessionDownloadTask *task = [[[DownloadManager shareInstance] downloadTasksDic] objectForKey:[file.filename stringByDeletingPathExtension]];
//    self.task = task;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tempArray  = [NSMutableArray array];
}

- (IBAction)refreshButtonClick:(UIBarButtonItem *)sender
{
    [self refreshHomeListFloder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)arrayWithCurrentNode:(NSString *)currentNode
{
    NSMutableArray *array               = [NSMutableArray array];
    for (HomeListDataModle *data in _listDataSourceArray)
    {
        if ([data.fatherNode rangeOfString:currentNode].location != NSNotFound)
        {
            data.isExpand               = [NSNumber numberWithBool:NO];
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
    
    float fileSize                  = [data.fileSize floatValue];
    if (fileSize > 0)
    {
        NSString *fileS             = [NSString stringWithFormat:@"%.2fB", fileSize];
        if (fileSize/1024.0 >= 1) {
            fileSize                = fileSize/1024.0;
            fileS                   = [NSString stringWithFormat:@"%.2fKB", fileSize];
            if (fileSize/1024 >= 1) {
                fileSize            = fileSize/1024.0;
                fileS               = [NSString stringWithFormat:@"%.2fMB", fileSize];
            }
        }
        cell.fileSizeLabel.text     = fileS;
    }else
        cell.fileSizeLabel.text     = @"";
    
    NSArray *sepNum                 = [data.currentNode componentsSeparatedByString:@"_"];
    cell.imgViewLeadingConstraint.constant  = 20 + (sepNum.count-3)*40;
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
        FloderDataModel *model                      = [_listDataSourceArray objectAtIndex:indexPath.row];
        if ([model.fileNameStr rangeOfString:@".pdf"].location != NSNotFound)
        {
            NSString *filePath                      = [FileManager getDownloadDirPathWithFloderModel:model];
            if (![FileManager fileIsExistAtPath:filePath])
            {
                UIAlertView *alertView              = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到下载页面下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }else
            {
                ReaderDocument *document                = [ReaderDocument withDocumentFilePath:filePath password:nil];
                ReaderViewController *readerViewController              = [[ReaderViewController alloc] initWithReaderDocument:document];
                readerViewController.delegate           = self;
                readerViewController.model              = model;
                readerViewController.modalTransitionStyle               = UIModalTransitionStyleCrossDissolve;
                readerViewController.modalPresentationStyle             = UIModalPresentationFullScreen;
                [self presentViewController:readerViewController animated:YES completion:nil];
            }
        }
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

#pragma mark - ReaderViewControllerDelegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DataRequest
- (void)refreshHomeListFloder
{
    [self.nodeArray removeAllObjects];
    [self.tempArray removeAllObjects];
    [_hud show:NO];
    
    
    [self requestWithFloderId:@"1" callBack:^(id data) {
        
        [_hud hide:YES];
        [self.listArray removeAllObjects];
        [self.listDataSourceArray removeAllObjects];
        [HomeDataHelperContext deleteObjects];
        for (int i = 0; i < _tempArray.count; i++)
        {
            FloderDataModel *model = [_tempArray objectAtIndex:i];
            NSLog(@"filetype %@", model.fileType);
        }
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
    [DataRequest requestAsyncUrl:[NSString stringWithFormat:@"%@%@/children", FloderUrl, requestID] responseClass:[FlorderResponseParse class] success:^(id data) {
        if ([data isKindOfClass:[FlorderResponseParse class]])
        {
            NSMutableArray *flordersArray   = [NSMutableArray array];
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
                    //                    NSLog(@"currentnode %@", data.currentNode);
                    //                    NSLog(@"filename %@", data.fileNameStr);
                    [self.tempArray addObject:data];
                    if ([data.canExpand boolValue])
                    {
                        NSLog(@"!-----is florder %@", data.currentNode);
                        [self.nodeArray addObject:data.currentNode];
                        [flordersArray addObject:data.currentNode];
                    }
                }
                //                NSLog(@"!===============");
            }
            [self.nodeArray removeObject:floderId];
            NSLog(@"!-----remove florder %@", floderId);
            for (int i = 0; i < flordersArray.count; i++)
            {
                //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestWithFloderId:[flordersArray objectAtIndex:i] callBack:callBack];
                //                    });
            }
            if (self.nodeArray.count == 0) {
//                NSLog(@"!-----last florder %@", [self.nodeArray objectAtIndex:0]);
                callBack(data);
            }
        }
    } failure:^(id data) {
    }];
}

@end

