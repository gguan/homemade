//
//  UIImage+Scale.m
//  ColorArt
//
//  Created by Fred Leitz on 2012-12-15.
//  Copyright (c) 2012 Fred Leitz. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)
- (UIImage*) scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)croppedToRect:(CGRect)rect
{
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    //draw
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    //capture resultant image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	//return image
	return image;
}
@end