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
#import "ReaderViewController.h"

#import "HomeDataHelper.h"
#import "Tools.h"
#import "HomeListDataModle.h"
#import "HomeDataModle.h"
#import "CommonDefine.h"

typedef NS_ENUM(NSInteger, FileManagerType)
{
    FileManagerTypeDownloading,
    FileManagerTypeDownloaded
};

@interface FileManagerViewController ()<ReaderViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, DownloadingCellDelegate, ASIProgressDelegate, ASIHTTPRequestDelegate, DownloadedCellDelegate>
{
    FileManagerType                 _managerType;
    NSTimer                         *_timer;
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
    [_tableView reloadData];
}
- (IBAction)downloadedBtnClick:(UIButton *)sender
{
    if (_managerType == FileManagerTypeDownloaded)
        return;
    _managerType                = FileManagerTypeDownloaded;
    [self _initialDownloadedData];
    [_tableView reloadData];
}

- (void)_initialDownloadingData// 获取本地保存的服务端所有的数据，然后剔除已经下载下来的数据
{
    [_listArray removeAllObjects];
    _listArray                  = [NSMutableArray array];
    [self _rankDownloadingData];
    
}

- (void)_rankDownloadingData
{
    [_listArray removeAllObjects];
    [self _rankDownloadDataWithNode:@"node_0"];
}

- (void)_rankDownloadDataWithNode:(NSString *)node
{
    NSMutableArray *tmpArray                = [NSMutableArray arrayWithArray:[HomeDataHelperContext fetchItemsMatching:@"fatherNode" forAttribute:node]];
    for (int i = 0; i < tmpArray.count; i++)
    {
        HomeListDataModle *model            = [tmpArray objectAtIndex:i];
        FloderDataModel *fileModel          = [[FloderDataModel alloc] init];
        fileModel.url                       = [NSString stringWithFormat:@"%@%@/content", ContentUrl, model.fileID];
        fileModel.fileNameStr               = model.fileNameStr;
        fileModel.fatherNode                = model.fatherNode;
        fileModel.fileSize                  = model.fileSize;
        fileModel.fileType                  = model.fileType;
        fileModel.date                      = model.date;
        fileModel.currentNode               = model.currentNode;
        
        NSString *filePath                  = [NSString stringWithFormat:@"%@/%@", [FileManager getDownloadDirPath], [NSString stringWithFormat:@"%@", model.fileNameStr]];
        if (![FileManager fileIsExistAtPath:filePath])// 树状结构只显示没有下载的文件
            [_listArray insertObject:fileModel atIndex:(_listArray.count )];

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
        NSString *filePath                  = [NSString stringWithFormat:@"%@/%@", [FileManager getDownloadDirPath], [NSString stringWithFormat:@"%@", model.fileNameStr]];
        if ([FileManager fileIsExistAtPath:filePath])
        {
            FloderDataModel *fileModel      = [[FloderDataModel alloc] init];
            fileModel.fileNameStr           = model.fileNameStr;
            fileModel.fatherNode            = model.fatherNode;
            fileModel.fileSize              = model.fileSize;
            fileModel.currentNode           = model.currentNode;
            fileModel.date                      = model.date;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_timer == nil) {
        _timer                  = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    }
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)timeAction:(id)userInfo
{
    for (int i = 0; i < [[[[DownloadManager shareInstance] queue] operations] count]; i++)
    {
        ASIHTTPRequest *rq          = [[[[DownloadManager shareInstance]queue] operations] objectAtIndex:i];
        for (int j = 0; j < _listArray.count; j++)
        {
            DownloadingCell *cell   = (DownloadingCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
            if ([[rq.userInfo objectForKey:@"key"] isEqualToString:cell.fileModel.url])
            {
                NSLog(@"total receive %lld", rq.totalBytesRead);
                float progress              = (rq.totalBytesRead*100.0)/[cell.fileModel.fileSize floatValue];
                cell.progressLabel.text     = [NSString stringWithFormat:@"%.2f%%", progress];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
        {
            cell.progressLabel.hidden               = YES;
            cell.downloadButton.hidden              = YES;
        }
        else
        {
            cell.progressLabel.hidden               = NO;
            cell.downloadButton.hidden              = NO;
            cell.delegate                           = self;
        }
        
        cell.titleLabel.text                        = model.fileNameStr;
        cell.fileModel                              = model;
        NSArray *sepNum                             = [model.currentNode componentsSeparatedByString:@"_"];
        cell.imgLineLayoutConstrains.constant       = 20 + (sepNum.count-2)*40;
        return cell;
    }
    else
    {
        DownloadedCell *cell                        = [tableView dequeueReusableCellWithIdentifier:@"downloadedcell"];
        FloderDataModel *model                      = [_listArray objectAtIndex:indexPath.row];
        cell.delegate                               = self;
        cell.titleLable.text                        = model.fileNameStr;
        cell.indexPath                              = indexPath;
        cell.imgLineLayoutConstrains.constant       = 20+40;
        cell.fileModel                              = model;
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
        FloderDataModel *model                      = [_listArray objectAtIndex:indexPath.row];
        if ([model.fileNameStr rangeOfString:@".pdf"].location != NSNotFound)
        {
            NSString *filePath                      = [FileManager getDownloadDirPathWithFloderModel:model];
            ReaderDocument *document                = [ReaderDocument withDocumentFilePath:filePath password:nil];
            ReaderViewController *readerViewController              = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate           = self;
            readerViewController.model              = model;
            readerViewController.modalTransitionStyle               = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle             = UIModalPresentationFullScreen;
            [self presentViewController:readerViewController animated:YES completion:nil];
        }
    }
    else if (_managerType == FileManagerTypeDownloading)
    {
        
    }
}
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bookMarkReadViewController:(ReaderViewController *)viewontroller
{
    FloderDataModel *model                          = viewontroller.model;
    NSString *markPath                              = [FileManager getBookMarkFile];
    NSMutableArray *fileArray                       = [NSKeyedUnarchiver unarchiveObjectWithFile:markPath];
    NSMutableArray *array                           = [NSMutableArray array];
    if (fileArray.count > 0) {
        array                                       = [NSMutableArray arrayWithArray:fileArray];
    }
    for (int i = 0; i < fileArray.count; i++) {
        FloderDataModel *tmpModel                   = [fileArray objectAtIndex:i];
        if ([tmpModel.fileNameStr isEqualToString:model.fileNameStr]) {
            // 已经存在
            UIAlertView *alertView                  = [[UIAlertView alloc] initWithTitle:@"已经收藏" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    [array addObject:model];
    [NSKeyedArchiver archiveRootObject:array toFile:markPath];
    UIAlertView *alertView                          = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    for (int i = 0; i < _listArray.count; i++)
    {
        DownloadingCell *cell           = (DownloadingCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.fileModel.url isEqualToString:[request.userInfo objectForKey:@"key"]])
        {
            cell.fileModel.downloadState = DownloadStateDownloading;
            cell.downloadState = DownloadStateDownloading;
            [_tableView reloadData];
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    for (int i = 0; i < _listArray.count; i++)
    {
        DownloadingCell *cell           = (DownloadingCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.fileModel.url isEqualToString:[request.userInfo objectForKey:@"key"]])
        {
            cell.fileModel.downloadState = DownloadStateDownloaded;
            cell.downloadState = DownloadStateDownloaded;
//            cell.progressLabel.text     = @"100.00%";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (_managerType == FileManagerTypeDownloaded)
//                {
//                    [self _initialDownloadedData];
//                }
//                else if (_managerType == FileManagerTypeDownloading)
                {
                    [self _initialDownloadingData];
                }
                [_tableView reloadData];
            });
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request failed");
}

#pragma mark - DownloadedCellDelegate
- (void)downloadedCellDelete:(DownloadedCell *)cell
{
    [_listArray removeObjectAtIndex:cell.indexPath.row];
    [FileManager deleteDownloadFileWithFloderModel:cell.fileModel];
    [_tableView reloadData];
}

#pragma mark - DownloadingCellDelegate
- (void)downloadingCell:(DownloadingCell *)cell data:(FloderDataModel *)model
{
    if (model.downloadState == DownloadStateNone)
    {
        cell.downloadState = DownloadStateDownloadWait;
        [[DownloadManager shareInstance] downloadFileWithFileModel:model delegate:self];
    }else if (model.downloadState == DownloadStateDownloading)
    {
        cell.downloadState = DownloadStateSuspend;
        cell.fileModel.downloadState = DownloadStateSuspend;
        [[DownloadManager shareInstance] suspendRequestWithFileModel:model];
    }else if (model.downloadState == DownloadStateSuspend)
    {
        cell.downloadState = DownloadStateDownloading;
        [[DownloadManager shareInstance] downloadFileWithFileModel:model delegate:self];
    }
}

@end
