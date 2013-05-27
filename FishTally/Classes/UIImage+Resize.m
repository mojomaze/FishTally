//
//  UIImage+Resize.m
//  MyLocations
//
//  Created by Mark Winkler on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizedImageWithBounds:(CGSize)bounds withAspectType:(ImageAspectType)aspectType
{
    UIImage *newImage = nil;
    if (aspectType == ImageAspectTypeFit) {
    
        CGFloat horizontalRatio = bounds.width / self.size.width;
        CGFloat verticalRatio = bounds.height / self.size.height;
        CGFloat ratio = MIN(horizontalRatio, verticalRatio);
        CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
        
        UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    } else {
    
        CGFloat aspectRatio = self.size.width / self.size.height;
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        CGFloat squareSide = self.size.height;
        
        if (aspectRatio > 1) {
            x = (self.size.width - self.size.height) * 0.5f;
        }
        else if (aspectRatio < 1) {
            y = (self.size.height - self.size.width) * 0.5f;
            squareSide = self.size.width;
        }
        
        CGRect rect = CGRectMake(x, y, squareSide, squareSide);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        
        UIGraphicsBeginImageContextWithOptions(bounds, YES, 0);
        [croppedImage drawInRect:CGRectMake(0, 0, bounds.width, bounds.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();

       
        UIGraphicsEndImageContext();
    }
    
    return newImage;
}

@end
