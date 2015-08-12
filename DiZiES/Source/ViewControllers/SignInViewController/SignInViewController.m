//
//  SignInViewController.m
//  DiZiES
//
//  Created by admin on 15/8/12.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "SignInViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>

@interface SignInViewController ()<UITableViewDataSource, UITableViewDelegate, MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView           *_mapView;
    AMapSearchAPI       *_searchAPI;
}

@property (strong, nonatomic) NSMutableArray *listArray;

@property (strong, nonatomic) IBOutlet UIView *mapContainerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MAMapServices sharedServices].apiKey = @"0a8eeb369c7f69aac240a96282e718a7";
    _mapView            = [[MAMapView alloc] initWithFrame:UIEdgeInsetsInsetRect(_mapContainerView.bounds, UIEdgeInsetsMake(0, 0, 0, 0))];
    _mapView.delegate = self;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapContainerView addSubview:_mapView];
    
    _searchAPI          = [[AMapSearchAPI alloc] initWithSearchKey:@"0a8eeb369c7f69aac240a96282e718a7" Delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - AMapSearchDelegate
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
}

#pragma mark - UIButtonAction
- (IBAction)cancelSignInButtonClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)completeSignInButtonClick:(UIBarButtonItem *)sender
{
    
}

@end
