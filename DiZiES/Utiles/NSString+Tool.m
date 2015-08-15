//
//  NSString+Tool.m
//  DiZiES
//
//  Created by admin on 15/6/7.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "NSString+Tool.h"
#import "FileManager.h"

@implementation NSString (Tool)

+ (NSString *)filePathWithName:(NSString *)name fileID:(NSString *)fileID
{
    NSString *filePath              = [NSString stringWithFormat:@"%@/%@_%@", [FileManager getDownloadDirPath], fileID, name];
    return filePath;
}

+ (NSString *)stringWithDateFormateWithDateString:(NSString *)dateString
{
    return [self stringWithDateFormate:@"YYYY-MM-dd hh:mm" dateString:dateString];
}

+ (NSString *)stringWithDateFormate:(NSString *)formate dateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

- (NSString *)encodeCNString
{
    NSString *urlString = (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)self, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 ));
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}

@end
