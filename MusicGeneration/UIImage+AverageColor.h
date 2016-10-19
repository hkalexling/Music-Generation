//
//  UIImage+AverageColor.h
//  MusicGeneration
//
//  Created by Alex Ling on 17/10/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(AverageColor)

- (void)CPUGetAverageColorWithHandler: (void (^)(UIColor *color)) handler;
- (void)GPUGetAverageColorWithHandler: (void (^)(UIColor *color)) handler;

@end
