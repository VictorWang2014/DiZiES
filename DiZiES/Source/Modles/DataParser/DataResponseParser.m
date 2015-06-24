//
//  DataResponseParser.m
//  DiZiES
//
//  Created by admin on 15/5/29.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DataResponseParser.h"
#import "Tools.h"
#import "UserInfoModle.h"
#import "HomeDataModle.h"

@implementation DataResponseParser

- (void)parserFromData:(NSString *)jsonString
{
    NSAssert(nil, @"SubClass need realize parserFromData: jsonString method");
}

@end

@implementation LoginResponseParse

- (void)parserFromData:(NSString *)jsonString
{
    NSDictionary *dic               = [NSJSONSerialization jsonDictionaryWithString:jsonString];
    if (dic)
    {
        _success                    = [[dic objectForKey:@"success"] intValue];
        self.success                = _success;
        if (_success)
        {
            NSDictionary *dataDic   = [dic objectForKey:@"data"];
            if ([dataDic isKindOfClass:[NSDictionary class]])
            {
                AppUserInfo.userName= [dataDic objectForKey:@"fullname"];
            }
        }
    }
}

@end


@implementation FlorderResponseParse

- (void)parserFromData:(NSString *)jsonString
{
    NSDictionary *dic               = [NSJSONSerialization jsonDictionaryWithString:jsonString];
    self.flordListArray             = [NSMutableArray array];
    if (dic)
    {
        self.success                = [[dic objectForKey:@"success"] intValue];
        if (_success)
        {
            NSArray *dataArray      = [dic objectForKey:@"data"];
            NSLog(@"%@", dataArray);
            if ([dataArray isKindOfClass:[NSArray class]])
            {
                if (dataArray.count >= 1)
                {
                    for (int i = 0; i < dataArray.count; i++)
                    {
                        NSDictionary *subDic            = [dataArray objectAtIndex:i];
                        FloderDataModel *dataModel      = [[FloderDataModel alloc] init];
                        dataModel.fileNameStr           = [subDic objectForKey:@"name"];
                        dataModel.fileID                = [subDic objectForKey:@"id"];
                        dataModel.fileSize              = [subDic objectForKey:@"size"];
                        dataModel.date                  = [NSString stringWithDateFormateWithDateString:[subDic objectForKey:@"date"]];
                        dataModel.fileType              = [subDic objectForKey:@"type"];
                        
                        if ([[subDic objectForKey:@"type"] isEqualToString:@"folder"])
                        {
                            dataModel.canExpand         = [NSNumber numberWithBool:YES];
                        }
                        else
                        {
                            dataModel.canExpand         = [NSNumber numberWithBool:NO];
                        }
                        dataModel.isExpand              = [NSNumber numberWithBool:NO];
                        [self.flordListArray addObject:dataModel];
                    }
                }
            }
        }
    }
}

@end








