//
//  UIImage+AverageColor.m
//  MusicGeneration
//
//  Created by Alex Ling on 17/10/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "UIImage+AverageColor.h"
#import <GPUImage/GPUImage.h>

struct pixel {
	unsigned char r, g, b, a;
};

@implementation UIImage(AverageColor)

- (void)GPUGetAverageColorWithHandler:(void (^)(UIColor *))handler {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:self];
		GPUImageAverageColor *averageColorFilter = [GPUImageAverageColor new];
		[averageColorFilter setColorAverageProcessingFinishedBlock:^(CGFloat r, CGFloat g, CGFloat b, CGFloat a, CMTime frameTime) {
			UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:a];
			dispatch_async(dispatch_get_main_queue(), ^{
				handler(color);
			});
		}];
		
		[picture addTarget:averageColorFilter];
		[picture useNextFrameForImageCapture];
		[picture processImage];
	});
}

- (void)CPUGetAverageColorWithHandler:(void (^)(UIColor *))handler{
	__block NSUInteger red = 0;
	__block NSUInteger green = 0;
	__block NSUInteger blue = 0;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		struct pixel* pixels = (struct pixel*) calloc(1, self.size.width * self.size.height * sizeof(struct pixel));
		if (pixels != nil){
			
			CGContextRef context = CGBitmapContextCreate(
																									 (void*) pixels,
																									 self.size.width,
																									 self.size.height,
																									 8,
																									 self.size.width * 4,
																									 CGImageGetColorSpace(self.CGImage),
																									 kCGImageAlphaPremultipliedLast
																									 );
			
			if (context){
				CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), self.CGImage);
				
				NSUInteger numberOfPixels = self.size.width * self.size.height;
				for (int i=0; i<numberOfPixels; i++) {
					red += pixels[i].r;
					green += pixels[i].g;
					blue += pixels[i].b;
				}
				
				red /= numberOfPixels;
				green /= numberOfPixels;
				blue/= numberOfPixels;
				
				
				CGContextRelease(context);
			}
			
			free(pixels);
		}
		UIColor *color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			handler(color);
		});
	});
}

@end
