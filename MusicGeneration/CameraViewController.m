//
//  CameraViewController.m
//  MusicGeneration
//
//  Created by Alex Ling on 18/10/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "CameraViewController.h"
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "Music.h"
#import "UIImage+FromCIImage.h"
#import "UIImage+AverageColor.h"

@interface CameraViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property GLKView *previewView;
@property CIContext *context;
@property EAGLContext *eaglContext;
@property AVCaptureDevice *captureDevice;
@property AVCaptureSession *captureSession;
@property dispatch_queue_t queueToken;
@property CGRect bounds;
@property UIView *colorView;
@property NSDate *lastMusicDate;

@end

@implementation CameraViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor clearColor];
	
	_eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	_previewView = [[GLKView alloc] initWithFrame:self.view.bounds context:_eaglContext];
	_previewView.enableSetNeedsDisplay = NO;
	
	_previewView.transform = CGAffineTransformMakeRotation(M_PI_2);
	_previewView.frame = self.view.bounds;
	
	[self.view addSubview:_previewView];
	
	[_previewView bindDrawable];
	_bounds = CGRectMake(0, 0, _previewView.drawableWidth, _previewView.drawableHeight);
	
	_colorView = [UIView new];
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	_colorView.frame = CGRectMake(width - 100, 0, 100, 100);
	[self.view addSubview:_colorView];
	
	_context = [CIContext contextWithEAGLContext:_eaglContext];
	if ([AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 0){
		[self capture];
	}
	else{
		NSLog(@"video capturing not supported in this device");
	}
}

- (void) capture {
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices){
		if (device.position == AVCaptureDevicePositionBack) {
			_captureDevice = device;
			break;
		}
	}
	
	NSError *error;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
	if (error){
		NSLog(@"failed to get input device with error: %@", error);
		return;
	}
	
	if (![_captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPresetHigh]){
		NSLog(@"high preset not supported in this device");
		return;
	}
	
	_captureSession = [AVCaptureSession new];
	_captureSession.sessionPreset = AVCaptureSessionPresetHigh;
	
	AVCaptureVideoDataOutput *output = [AVCaptureVideoDataOutput new];
	output.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
	
	_queueToken = dispatch_queue_create("outputQueue.hkalexling.com", nil);
	[output setSampleBufferDelegate:self queue:_queueToken];
	output.alwaysDiscardsLateVideoFrames = YES;
	
	[_captureSession beginConfiguration];
	
	if (![_captureSession canAddOutput:output]){
		NSLog(@"cannot add output");
		return;
	}
	[_captureSession addInput:input];
	[_captureSession addOutput:output];
	[_captureSession commitConfiguration];
	[_captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	CIImage *ciImage = [CIImage imageWithCVPixelBuffer:(CVPixelBufferRef)imageBuffer];
	
	CGRect extent = ciImage.extent;
	
	[_previewView bindDrawable];
	if (_eaglContext != [EAGLContext currentContext]){
		[EAGLContext setCurrentContext:_eaglContext];
	}
	
	glClearColor(0.5, 0.5, 0.5, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	
	[_context drawImage:ciImage inRect:_bounds fromRect:extent];
	UIImage *img = [UIImage fromCIImage:ciImage];
	[img getAverageColorWithHandler:^(UIColor *color, NSError *error) {
		if (!error){
			_colorView.backgroundColor = color;
			[self musicFromColor:color];
		}
	}];
	
	[_previewView display];
}

- (void)musicFromColor:(UIColor *)color{
	// Red value determines the interval between sounds
	// Green value determines sound type
	// Blue value determines pitch
	
	const CGFloat* components = CGColorGetComponents(color.CGColor);
	CGFloat r = components[0];
	CGFloat g = components[1];
	CGFloat b = components[2];
	
	NSDate *current = [NSDate date];
	if (_lastMusicDate){
		NSTimeInterval interval = [current timeIntervalSinceDate:_lastMusicDate];
		if (interval < r){
			return;
		}
	}
	_lastMusicDate = current;
	
	MusicType type;
	if (g < 1/3.0){
		type = MusicTypeCelesta;
	}
	else if (g < 2/3.0){
		type = MusicTypeClav;
	}
	else{
		type = MusicTypeSwells;
	}
	
	[Music playType:type withPitch:b];
}

@end
