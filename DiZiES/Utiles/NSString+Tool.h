//
//  NSString+Tool.h
//  DiZiES
//
//  Created by admin on 15/6/7.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)

+ (NSString *)filePathWithName:(NSString *)name fileID:(NSString *)fileID;

+ (NSString *)stringWithDateFormateWithDateString:(NSString *)dateString;

+ (NSString *)stringWithDateFormate:(NSString *)formate dateString:(NSString *)dateString;

@end
