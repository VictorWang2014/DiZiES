//
//  DataResponseParser.h
//  DiZiES
//
//  Created by admin on 15/5/29.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModle.h"

@interface DataResponseParser : NSObject

- (void)parserFromData:(NSString *)jsonString;

@end


@interface LoginResponseParse : DataResponseParser

@property (nonatomic) int success;

@property (nonatomic, retain) UserInfoModle *userInfo;

@end