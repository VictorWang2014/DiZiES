//
//  NSJSONSerialization+Tool.m
//  DiZiES
//
//  Created by admin on 15/6/2.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "NSJSONSerialization+Tool.h"

@implementation NSJSONSerialization (Tool)

+ (NSDictionary *)jsonDictionaryWithString:(NSString *)jsonString
{
    NSData *data                = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic           = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return dic;
}

@end
