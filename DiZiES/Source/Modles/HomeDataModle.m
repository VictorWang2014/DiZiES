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
    [aCoder encodeObject:self.fileType forKey:@"filetype"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.fatherNode forKey:@"fatherNode"];
    [aCoder encodeObject:self.currentNode forKey:@"currentNode"];
    [aCoder encodeObject:self.canExpand forKey:@"canExpand"];
    [aCoder encodeObject:self.isExpand forKey:@"isExpand"];
    [aCoder encodeObject:self.isDownloaded forKey:@"isDownloaded"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.fileID             = [aDecoder decodeObjectForKey:@"fileid"];
        self.fileType           = [aDecoder decodeObjectForKey:@"filetype"];
        self.fileNameStr        = [aDecoder decodeObjectForKey:@"filenamestr"];
        self.fileSize           = [aDecoder decodeObjectForKey:@"filesize"];
        self.date               = [aDecoder decodeObjectForKey:@"date"];
        self.url                = [aDecoder decodeObjectForKey:@"url"];
        self.fatherNode         = [aDecoder decodeObjectForKey:@"fatherNode"];
        self.currentNode        = [aDecoder decodeObjectForKey:@"currentNode"];
        self.canExpand          = [aDecoder decodeObjectForKey:@"canExpand"];
        self.isExpand           = [aDecoder decodeObjectForKey:@"isExpand"];
        self.isDownloaded       = [aDecoder decodeObjectForKey:@"isDownloaded"];
    }
    return self;
}

@end

