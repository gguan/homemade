//
//  UIImage+ColorImage.m
//  homemade
//
//  Created by Guan Guan on 7/4/13.
//  Copyright (c) 2013 Guan Guan. All rights reserved.
//

#import "UIImage+ColorImage.h"

@implementation UIImage (ColorImage)

//change the nipple image color to required color
-(UIImage*)changeImageToColor:(UIColor*)color {
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  [UIImage imageWithCGImage:img.CGImage
                                scale:1.0 orientation: UIImageOrientationDownMirrored];
    
}

@end
