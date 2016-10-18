//
//  ViewController.m
//  RealtimeVideoFilter
//
//  Created by Altitude Labs on 23/12/15.
//  Copyright © 2015 Victor. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor clearColor];
	CameraViewController *cameraVC = [CameraViewController new];
	cameraVC.preferredContentSize = self.view.bounds.size;
	[self addChildViewController:cameraVC];
	[self.view addSubview:cameraVC.view];
}

@end
