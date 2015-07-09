//
//  PersonalCenterViewController.m
//  EBS
//
//  Created by 王明权 on 15/5/13.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "Tools.h"
#import "ReaderViewController.h"

@interface PersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate, ReaderViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.editBtn                                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.editBtn sizeToFit];
    [self.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem          = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _loadData];
}

- (void)_loadData
{
    NSString *markPath                              = [FileManager getBookMarkFile];
    self.listArray                                  = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:markPath]];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editBtnClick:(UIButton *)button
{
    if (!_tableView.isEditing)
    {
        [_tableView setEditing:YES animated:YES];
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else
    {
        [_tableView setEditing:NO animated:YES];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier                     = @"identifier";
    UITableViewCell *cell                           = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell                                        = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    FloderDataModel *model                          = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text                             = model.fileNameStr;
    cell.imageView.image                            = [UIImage imageNamed:@"folder.png"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_listArray removeObjectAtIndex:indexPath.row];
        NSString *markPath                              = [FileManager getBookMarkFile];
        [NSKeyedArchiver archiveRootObject:_listArray toFile:markPath];
        [_tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self _loadData];
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

@end
