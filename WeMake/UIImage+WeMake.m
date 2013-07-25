//
//  UIImage+WeMake.m
//  WeMake
//
//  Created by Michael Scaria on 7/13/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "UIImage+WeMake.h"

@implementation UIImage (WeMake)
+ (UIImage *)ipMaskedImageNamed:(NSString *)name color:(UIColor *)color {
    UIImage *image = [UIImage imageNamed:name];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}
@end
