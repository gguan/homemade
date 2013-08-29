//
//  UIColor+String.m
//  homemade
//
//  Created by Guan Guan on 6/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "UIColor+String.h"

@implementation UIColor (String)

+ (NSString *)colorToString:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
    return colorAsString;
}

+ (UIColor *)stringToColor:(NSString *)colorAsString {
    NSArray *components = [colorAsString componentsSeparatedByString:@","];
    CGFloat r = [[components objectAtIndex:0] floatValue];
    CGFloat g = [[components objectAtIndex:1] floatValue];
    CGFloat b = [[components objectAtIndex:2] floatValue];
    CGFloat a = [[components objectAtIndex:3] floatValue];
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
