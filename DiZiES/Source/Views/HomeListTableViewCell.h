//
//  HomeListTableViewCell.h
//  DiZiES
//
//  Created by admin on 15/5/21.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView  *fileImg;

@property (nonatomic, strong) IBOutlet UILabel      *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *sepLineImg;

@end
