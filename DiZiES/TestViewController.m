//
//  TestViewController.m
//  DiZiES
//
//  Created by admin on 15/5/30.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "TestViewController.h"
#import "HomeDataHelper.h"
#import "Tools.h"
#import "HomeListDataModle.h"
#import "HomeDataModle.h"
#import "CommonDefine.h"

@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableURLRequest *_request;
}
@property (nonatomic, strong) NSMutableArray            *listArray;

@end

@implementation TestViewController
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *di = @"kasjdf";
    UITableViewCell *cel = [tableView dequeueReusableCellWithIdentifier:di];
    if (cel == nil) {
        cel = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:di];
    }
    FloderDataModel *model                      = [_listArray objectAtIndex:indexPath.row];
    cel.textLabel.text = model.fileNameStr;
    return cel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FloderDataModel *model                      = [_listArray objectAtIndex:indexPath.row];
    model.url = @"http://player.youku.com/player.php/sid/XMTMyNDc4Njc2NA==/v.swf";
    [[SingleDownloadQueue shareInstance] downloadFileModel:model];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _listArray                  = [NSMutableArray array];

}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *dir = [FileManager getLibraryPath];
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/VictorWangDir", dir] error:nil];
    [super viewWillAppear:animated];
    [self _rankDownloadingData];
}
- (void)_rankDownloadingData
{
    [_listArray removeAllObjects];
    [self _rankDownloadDataWithNode:@"node_0"];
    [_tableView reloadData];
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
        NSLog(@"file url %@", fileModel.url);
        NSString *filePath                  = [NSString stringWithFormat:@"%@/%@", [FileManager getDownloadDirPath], [NSString stringWithFormat:@"%@", model.fileNameStr]];
        if (![FileManager fileIsExistAtPath:filePath])// 树状结构只显示没有下载的文件
            [_listArray insertObject:fileModel atIndex:(_listArray.count )];
        
        if ([fileModel.fileType isEqualToString:@"folder"])
        {
            [self _rankDownloadDataWithNode:model.currentNode];
        }
    }
}

- (void)getRootDirect
{
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ebsctgmgt.padccc.net/restapi/index.php/folder/1/children"]];
    [_request setHTTPMethod:@"GET"];
    [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:_request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"!-------%@", string);
    }];
    
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://ebsctgmgt.padccc.net/restapi/index.php/folder/1/children"] usedEncoding:nil error:nil];
    NSLog(@"!-＋＋＋＋＋%@", string);
}

@end

