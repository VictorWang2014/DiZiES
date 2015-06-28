//
//  DownloadTestViewController.m
//  DiZiES
//
//  Created by admin on 15/6/27.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DownloadTestViewController.h"
#import "HomeDataHelper.h"
#import "Tools.h"
#import "HomeListDataModle.h"
#import "HomeDataModle.h"
#import "CommonDefine.h"

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface DownloadTestViewController ()

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation DownloadTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initialDownloadingData];
    // Do any additional setup after loading the view.
    FloderDataModel *dataModel = [_listArray objectAtIndex:0];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+40, 200, 30)];
    label1.textColor = [UIColor whiteColor];
    label1.text = dataModel.fileNameStr;
    [self.view addSubview:label1];
    UIButton *button1   = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"点击下载 " forState:UIControlStateNormal];
    button1.frame       = CGRectMake(200, 0+40, 150, 30);
    [button1 addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag         = 1;
    [self.view addSubview:button1];
    
    dataModel = [_listArray objectAtIndex:1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40+40, 200, 30)];
    label2.textColor = [UIColor whiteColor];
    label2.text = dataModel.fileNameStr;
    [self.view addSubview:label2];
    UIButton *button2   = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"点击下载 " forState:UIControlStateNormal];
    button2.frame       = CGRectMake(200, 40+40, 150, 30);
    [button2 addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag         = 2;
    [self.view addSubview:button2];
    
    dataModel = [_listArray objectAtIndex:2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80+40, 200, 30)];
    label3.textColor = [UIColor whiteColor];
    label3.text = dataModel.fileNameStr;
    [self.view addSubview:label3];
    UIButton *button3   = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"点击下载 " forState:UIControlStateNormal];
    button3.frame       = CGRectMake(200, 80+40, 150, 30);
    [button3 addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag         = 3;
    [self.view addSubview:button3];
    
    dataModel = [_listArray objectAtIndex:3];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 120+40, 200, 30)];
    label4.textColor = [UIColor whiteColor];
    label4.text = dataModel.fileNameStr;
    [self.view addSubview:label4];
    UIButton *button4   = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setTitle:@"点击下载 " forState:UIControlStateNormal];
    button4.frame       = CGRectMake(200, 120+40, 150, 30);
    [button4 addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button4.tag         = 4;
    [self.view addSubview:button4];
    
//    dataModel = [_listArray objectAtIndex:4];
//    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 200, 30)];
//    label5.text = dataModel.fileNameStr;
//    [self.view addSubview:label5];
//    UIButton *button5   = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button5 setTitle:@"点击下载 " forState:UIControlStateNormal];
//    button5.frame       = CGRectMake(200, 160, 150, 30);
//    [button5 addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    button5.tag         = 5;
//    [self.view addSubview:button5];
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
        fileModel.currentNode               = model.currentNode;
        NSString *filePath                  = [NSString stringWithFormat:@"%@/%@", [FileManager getDownloadDirPath], [NSString stringWithFormat:@"%lu_%@", (unsigned long)[[NSString stringWithFormat:@"%@/%@/content", ContentUrl, model.fileID] hash], model.fileNameStr]];
        
        NSLog(@"%@", filePath);
        if (![FileManager fileIsExistAtPath:filePath] && [fileModel.fileType isEqualToString:@"document"])// 树状结构只显示没有下载的文件
            [_listArray insertObject:fileModel atIndex:_listArray.count];
        
        if ([fileModel.fileType isEqualToString:@"folder"])
        {
            [self _rankDownloadDataWithNode:model.currentNode];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadBtnClick:(UIButton *)button
{
    [button setTitle:@"正在下载" forState:UIControlStateNormal];
    if (button.tag == 1)
    {

    }
    else if (button.tag == 2)
    {
        
    }
    else if (button.tag == 3)
    {
        
    }
    else if (button.tag == 4)
    {
        
    }
    else if (button.tag == 5)
    {
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



@interface Downloader ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) ASINetworkQueue *queue;

@end

@implementation Downloader

+ (Downloader *)shareInstance
{
    static Downloader *downloader   = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch , ^{
        downloader                  = [[Downloader alloc] init];
    });
    return downloader;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.queue                  = [[ASINetworkQueue alloc] init];
        [self.queue setShowAccurateProgress:YES];
        [self.queue go];
        [self _resumeDownloadTmpFile];
    }
    return self;
}

- (void)_resumeDownloadTmpFile
{
    
}

- (void)downloadFileWithFileModel:(FloderDataModel *)model
{
    NSAssert(model.url.length > 0, @"download url is not valid");
    NSURL *nUrl             = [NSURL URLWithString:model.url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nUrl];
    request.delegate        = self;
    [request setDownloadDestinationPath:[FileManager getDownloadDirPathWithFloderModel:model]];
    request setTemporaryFileDownloadPath:<#(NSString *)#>
}

@end


