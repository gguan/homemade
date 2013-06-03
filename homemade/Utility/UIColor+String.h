//
//  UIColor+String.h
//  homemade
//
//  Created by Guan Guan on 6/3/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (String)

+ (NSString *)colorToString:(UIColor *)color;
+ (UIColor *)stringToColor:(NSString *)value;

@end
