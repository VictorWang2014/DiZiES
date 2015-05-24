//
//  MainTableViewCell.m
//  DiZiES
//
//  Created by admin on 15/5/23.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "MainTableViewCell.h"
#import "Tools.h"

@implementation MainTableViewCell

- (void)setCellSelect:(BOOL)select data:(MainDataModle *)data
{
    self.titleLabel.text            = data.titleStr;
    if (select)
    {
        self.selectBGView.image     = [UIImage imageWithColor:UIColorWith(26, 26, 26) size:CGSizeMake(self.EWidth, 60)];
        self.titleLabel.textColor   = UIColorWith(82, 168, 240);
        self.imgView.image          = [UIImage imageNamed:data.selectImageNaemStr];
    }
    else
    {
        self.imgView.image          = [UIImage imageNamed:data.imageNameStr];
        self.selectBGView.image     = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(self.EWidth, 60)];
        self.titleLabel.textColor   = [UIColor whiteColor];
    }
}

@end

@implementation MainPersonTableViewCell



@end