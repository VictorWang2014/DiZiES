//
//  UIView+Tool.m
//  EBS
//
//  Created by 王明权 on 15/5/13.
//  Copyright (c) 2015年 com.gw.cn.MrsWang. All rights reserved.
//

#import "UIView+Tool.h"

@implementation UIView (Tool)

- (void)setEHeight:(CGFloat)EHeight
{
    CGRect rect         = self.frame;
    rect.size.height    = EHeight;
    self.frame          = rect;
}

- (CGFloat)EHeight
{
    return self.frame.size.height;
}

- (void)setEWidth:(CGFloat)EWidth
{
    CGRect rect         = self.frame;
    rect.size.width     = EWidth;
    self.frame          = rect;
}

- (CGFloat)EWidth
{
    return self.frame.size.width;
}

- (void)setEBorderColor:(UIColor *)EBorderColor
{
    CALayer *layer      = self.layer;
    layer.borderColor   = EBorderColor.CGColor;
}

- (UIColor *)EBorderColor
{
    CALayer *layer      = self.layer;
    return (UIColor *)layer.borderColor;
}

- (void)setEBorderWidth:(CGFloat)EBorderWidth
{
    CALayer *layer      = self.layer;
    layer.borderWidth   = EBorderWidth;
}

- (CGFloat)EBorderWidth
{
    CALayer *layer      = self.layer;
    return layer.borderWidth;
}

- (void)setECornerRadius:(CGFloat)ECornerRadius
{
    self.clipsToBounds  = YES;
    CALayer *layer      = self.layer;
    layer.cornerRadius  = ECornerRadius;
}

- (CGFloat)ECornerRadius
{
    CALayer *layer      = self.layer;
    return layer.cornerRadius;
}

@end
