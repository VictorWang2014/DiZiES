//
//  UIColor+Tool.h
//  DiZiES
//
//  Created by admin on 15/5/20.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//

#import <UIKit/UIKit.h>


#define UIColorWith(a, b ,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]
#define UIColorRandomColor  [UIColor randomColor]

@interface UIColor (Tool)

+ (UIColor *)randomColor;

@end
