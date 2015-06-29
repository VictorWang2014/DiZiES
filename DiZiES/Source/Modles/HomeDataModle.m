//
//  HomeDataModle.m
//  DiZiES
//
//  Created by admin on 15/5/21.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "HomeDataModle.h"

@implementation HomeDataModle

@end


@implementation FloderDataModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileID forKey:@"fileid"];
    [aCoder encodeObject:self.fileNameStr forKey:@"filenamestr"];
    [aCoder encodeObject:self.fileSize forKey:@"filesize"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.url forKey:@"url"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.fileID             = [aDecoder decodeObjectForKey:@"fileid"];
        self.fileNameStr        = [aDecoder decodeObjectForKey:@"filenamestr"];
        self.fileSize           = [aDecoder decodeObjectForKey:@"filesize"];
        self.date               = [aDecoder decodeObjectForKey:@"date"];
        self.url                = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}

@end

