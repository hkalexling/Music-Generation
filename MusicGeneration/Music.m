//
//  Music.m
//  MusicGeneration
//
//  Created by Alex Ling on 17/10/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "Music.h"

@implementation Music

- (instancetype) initWithType:(MusicType)type {
	self = [Music new];
	if (self) {
		self.type = type;
	}
	return self;
}

+ (void)playType:(MusicType)type withPitch:(CGFloat)pitch {
	pitch = MIN(1.0, MAX(0.0, pitch));
	
	NSInteger count = [[MusicCount valueForKey:type] integerValue];
	NSInteger fileIndex = (NSInteger)roundf(pitch * (count - 1));
	
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-%li", type,(long)fileIndex] ofType:@"mp3"];
	NSURL *url = [NSURL fileURLWithPath:path];
	
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
	AudioServicesPlaySystemSound(soundID);
}

- (void)playWithPitch:(CGFloat)pitch {
	[Music playType:_type withPitch:pitch];
}

@end
