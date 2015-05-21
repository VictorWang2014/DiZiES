//
//  UIColor+Tool.m
//  DiZiES
//
//  Created by admin on 15/5/20.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import "UIColor+Tool.h"

@implementation UIColor (Tool)

+ (UIColor *)randomColor
{
    CGFloat red         = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green       = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue        = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];    
}

@end
