//
//  UIImage+FromCIImage.m
//  MusicGeneration
//
//  Created by Alex Ling on 18/10/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "UIImage+FromCIImage.h"

@implementation UIImage(FromCIImage)

+ (UIImage *)fromCIImage:(CIImage *)image {
	CIContext *ciContext = [CIContext contextWithOptions:nil];
	CGImageRef cgImage = [ciContext createCGImage:image fromRect:[image extent]];
	UIImage *img = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	return img;
}

@end
