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
//#import <AMapNaviKit/MAMapKit.h>
//#import <AMapNaviKit/AMapNaviKit.h>

@interface SignInViewController ()<AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate, MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView           *_mapView;
    MAUserLocation      *_userLocation;
    BOOL                _showUserLocation;
}

@property (strong, nonatomic) NSMutableArray *poiAnnotations;

@property (strong, nonatomic) IBOutlet UIView *mapContainerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.poiAnnotations = [NSMutableArray array];
    _showUserLocation   = YES;
    // Do any additional setup after loading the view.
    [MAMapServices sharedServices].apiKey = @"0a8eeb369c7f69aac240a96282e718a7";
    _mapView            = [[MAMapView alloc] initWithFrame:UIEdgeInsetsInsetRect(_mapContainerView.bounds, UIEdgeInsetsMake(0, 0, 0, 0))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [_mapContainerView addSubview:_mapView];
    self.search          = [[AMapSearchAPI alloc] initWithSearchKey:@"0a8eeb369c7f69aac240a96282e718a7" Delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)requestCurrenPlaceAround
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    if (_userLocation)
    {
        request.location = [AMapGeoPoint locationWithLatitude:_userLocation.location.coordinate.latitude
                                                    longitude:_userLocation.location.coordinate.longitude];
    }
    else
    {
        request.location = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.471476];
    }
    request.searchType          = AMapSearchType_PlaceID;
    request.keywords            = @"";
    request.sortrule            = 1;
    request.requireExtension    = NO;
    [self.search AMapPlaceSearch:request];
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_poiAnnotations.count == 0)
        return 1000;
    
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_poiAnnotations.count == 0)
        return 1;
    return _poiAnnotations.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation)
    {
        _userLocation = userLocation;
        if (_showUserLocation) {
            [self requestCurrenPlaceAround];
        }
    }
}
#pragma mark - AMapSearchDelegate
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"SearchError:{%@}", error.localizedDescription);
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    if (respons.pois.count == 0)
    {
        return;
    }
    _showUserLocation = NO;
//    [_mapView removeAnnotations:_poiAnnotations];
    [_poiAnnotations removeAllObjects];
    
    [respons.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake(obj.location.latitude, obj.location.longitude)];
        [annotation setTitle:obj.name];
        [annotation setSubtitle:obj.address];
        
        [_poiAnnotations addObject:annotation];
    }];
    
//    [self showPOIAnnotations];
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
