//
//  ViewController.m
//  RealtimeVideoFilter
//
//  Created by Altitude Labs on 23/12/15.
//  Copyright © 2015 Victor. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"
#import "UIImage+AverageColor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	UIImage *img = [UIImage imageNamed:@"yuno"];
//	
//	NSDate *start = [NSDate date];
//	[img averageColor:^(UIColor *color) {
//		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:start];
//		NSLog(@"gpu time: %f", interval);
////		self.view.backgroundColor = color;
//	}];
//	
//	NSDate *newStart = [NSDate date];
//	[img getAverageColorWithHandler:^(UIColor *color, NSError *error) {
//		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:newStart];
//		NSLog(@"cpu time: %f", interval);
//	}];
	
//	NSDate *date = [NSDate date];
//	[img averageColorFromMerge:^(UIColor *color) {
//		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
//		NSLog(@"merge time: %f", interval);
//	}];
	
	self.view.backgroundColor = [UIColor clearColor];
	CameraViewController *cameraVC = [CameraViewController new];
	cameraVC.preferredContentSize = self.view.bounds.size;
	[self addChildViewController:cameraVC];
	[self.view addSubview:cameraVC.view];
}

@end
