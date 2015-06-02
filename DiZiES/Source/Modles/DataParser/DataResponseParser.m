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
    if (dic)
    {
        self.success                = [[dic objectForKey:@"success"] intValue];
        if (_success)
        {
            NSArray *dataArray      = [dic objectForKey:@"data"];
            if ([dataArray isKindOfClass:[NSArray class]])
            {
                if (dataArray.count > 1)
                {
                    for (int i = 0; i < dataArray.count; i++)
                    {
                        NSDictionary *subDic            = [dataArray objectAtIndex:i];
                        HomeDataModle *dataModel        = [[HomeDataModle alloc] init];
                        dataModel.
                    }
                }
            }
        }
    }
}

@end