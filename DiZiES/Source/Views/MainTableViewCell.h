//
//  MainTableViewCell.h
//  DiZiES
//
//  Created by admin on 15/5/23.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainDataModle.h"

@interface MainTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectBGView;

- (void)setCellSelect:(BOOL)select data:(MainDataModle *)data;

@end



@interface MainPersonTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView      *imgeView;//用户头像
@property (nonatomic, strong) IBOutlet UILabel          *titleLabel;//用户名
@property (nonatomic, strong) IBOutlet UILabel          *detailLabel;//用户信息

@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@end
