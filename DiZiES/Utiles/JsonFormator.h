//
//  JsonFormator.h
//  DiZiES
//
//  Created by admin on 15/5/31.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonFormator : NSObject

+ (NSString *)formatorString:(NSString *)string withKey:(NSString *)key;

@end
