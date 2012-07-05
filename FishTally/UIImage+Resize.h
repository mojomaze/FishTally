//
//  UIImage+Resize.h
//  MyLocations
//
//  Created by Mark Winkler on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

typedef enum {
    ImageAspectTypeFill,
    ImageAspectTypeFit
} ImageAspectType;

- (UIImage *)resizedImageWithBounds:(CGSize)bounds withAspectType:(ImageAspectType)aspectType;

@end
