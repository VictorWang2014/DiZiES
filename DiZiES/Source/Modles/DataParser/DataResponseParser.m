//
//  DataResponseParser.m
//  DiZiES
//
//  Created by admin on 15/5/29.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "DataResponseParser.h"

@implementation DataResponseParser

- (void)parserFromData:(NSString *)jsonString
{
    NSAssert(nil, @"SubClass need realize parserFromData: jsonString method");
}

@end

@implementation LoginResponseParse

- (void)parserFromData:(NSString *)jsonString
{
    
}

@end