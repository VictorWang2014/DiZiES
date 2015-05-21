//
//  HomeListTableViewCell.m
//  DiZiES
//
//  Created by admin on 15/5/21.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "HomeListTableViewCell.h"

@implementation HomeListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _fileImg.translatesAutoresizingMaskIntoConstraints          = NO;
        _titleLabel.translatesAutoresizingMaskIntoConstraints       = NO;
        
    }
    return self;
}

@end
