//
//  DownloadedCell.m
//  DiZiES
//
//  Created by admin on 15/6/18.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DownloadedCell.h"

@implementation DownloadedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonClick:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(downloadedCellDelete:)])
    {
        [_delegate downloadedCellDelete:self];
    }
}

@end
