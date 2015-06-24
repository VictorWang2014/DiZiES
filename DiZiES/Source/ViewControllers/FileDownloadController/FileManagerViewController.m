//
//  FileManagerViewController.m
//  EBS
//
//  Created by 王明权 on 15/5/13.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import "FileManagerViewController.h"
#import "DownloadedCell.h"
#import "DownloadingCell.h"

#import "HomeDataHelper.h"
#import "Tools.h"
#import "HomeListDataModle.h"
#import "CommonDefine.h"

typedef NS_ENUM(NSInteger, FileManagerType)
{
    FileManagerTypeDownloading,
    FileManagerTypeDownloaded
};

@interface FileManagerViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    FileManagerType                 _managerType;
}

@property (strong, nonatomic) IBOutlet UIView           *navTitleView;
@property (strong, nonatomic) IBOutlet UIButton         *leftButton;
@property (strong, nonatomic) IBOutlet UIButton         *rightButton;

@property (strong, nonatomic) IBOutlet UITableView      *tableView;

@property (nonatomic, strong) NSMutableArray            *listArray;
@property (nonatomic, strong) NSMutableArray            *sourceArray;


@end

@implementation FileManagerViewController

- (IBAction)downloadingBtnClick:(UIButton *)sender
{
    if (_managerType == FileManagerTypeDownloading)
        return;
    _managerType                = FileManagerTypeDownloading;
    [self _initialDownloadingData];
}
- (IBAction)downloadedBtnClick:(UIButton *)sender
{
    if (_managerType == FileManagerTypeDownloaded)
        return;
    _managerType                = FileManagerTypeDownloaded;
    [self _initialDownloadedData];
}

- (void)_initialDownloadingData// 获取本地保存的服务端所有的数据，然后剔除已经下载下来的数据
{
    [_listArray removeAllObjects];
    _listArray                  = [NSMutableArray array];
    [self _rankDownloadingData];
}

- (void)_rankDownloadingData
{
    [self _rankDownloadDataWithNode:@"node_0"];
}

- (void)_rankDownloadDataWithNode:(NSString *)node
{
    NSMutableArray *tmpArray                = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:@"fatherNode" forAttribute:node]];
    for (int i = 0; i < tmpArray.count; i++)
    {
        HomeListDataModle *model            = [tmpArray objectAtIndex:i];
        FloderDataModel *fileModel          = [[FloderDataModel alloc] init];
        fileModel.fileNameStr               = model.fileNameStr;
        fileModel.fatherNode                = model.fatherNode;
        fileModel.fileSize                  = model.fileSize;
        fileModel.fileType                  = model.fileType;
        fileModel.currentNode               = model.currentNode;
        fileModel.url                       = [NSString stringWithFormat:@"%@/%@/content", ContentUrl, model.fileID];
        NSString *filePath      = [FileManager getDownloadCachesDirPathWithName:[NSString stringWithFormat:@"%d_%@", [[NSString stringWithFormat:@"%@/%@/content", ContentUrl, model.fileID] hash], model.fileNameStr]];
        if (![FileManager fileIsExistAtPath:filePath])// 树状结构只显示没有下载的文件
        {
            [_listArray insertObject:fileModel atIndex:(_listArray.count )];
        }
        if ([fileModel.fileType isEqualToString:@"folder"])
        {
            [self _rankDownloadDataWithNode:model.currentNode];
        }
    }
}

- (void)_initialDownloadedData
{
    [_listArray removeAllObjects];
    _listArray                  = [NSMutableArray array];
    NSMutableArray *array       = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:nil forAttribute:nil]];
    for (HomeListDataModle *model in array)
    {
        NSString *filePath      = [FileManager getDownloadCachesDirPathWithName:[NSString stringWithFormat:@"%d_%@", [[NSString stringWithFormat:@"%@/%@/content", ContentUrl, model.fileID] hash], model.fileNameStr]];
        if ([FileManager fileIsExistAtPath:filePath])
        {
            FloderDataModel *fileModel      = [[FloderDataModel alloc] init];
            fileModel.fileNameStr           = model.fileNameStr;
            fileModel.fatherNode            = model.fatherNode;
            fileModel.fileSize              = model.fileSize;
            fileModel.currentNode           = model.currentNode;
            fileModel.url                   = [NSString stringWithFormat:@"%@/%@/content", ContentUrl, model.fileID];
            [_listArray addObject:fileModel];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listArray              = [NSMutableArray array];
    self.sourceArray            = [NSMutableArray array];
    _managerType                = FileManagerTypeDownloading;
    [self _initialDownloadingData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_managerType == FileManagerTypeDownloading)
    {
        DownloadingCell *cell                       = [tableView dequeueReusableCellWithIdentifier:@"downloadingcell"];
        FloderDataModel *model                      = [_listArray objectAtIndex:indexPath.row];
        if ([model.fileType isEqualToString:@"folder"])
            cell.downloadButton.hidden              = YES;
        else
            cell.downloadButton.hidden              = NO;
        
        cell.titleLabel.text                        = model.fileNameStr;
        cell.fileModel                              = model;
        NSArray *sepNum                             = [model.currentNode componentsSeparatedByString:@"_"];
        cell.imgLineLayoutConstrains.constant       = 20 + (sepNum.count-2)*40;
//        cell.dataLabel.text                         = data.date;
        return cell;
    }
    else
    {
        DownloadedCell *cell                        = [tableView dequeueReusableCellWithIdentifier:@"downloadedcell"];
        FloderDataModel *model                      = [_listArray objectAtIndex:indexPath.row];
        cell.titleLable.text                        = model.fileNameStr;
//        cell.dataLabel.text                         = data.date;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_managerType == FileManagerTypeDownloaded)
    {
        
    }
}


@end
