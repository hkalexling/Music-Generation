//
//  UIImage+FromCIImage.h
//  MusicGeneration
//
//  Created by Alex Ling on 18/10/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(FromCIImage)

+ (UIImage *)fromCIImage:(CIImage *)image;

@end
