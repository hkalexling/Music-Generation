//
//  Music.h
//  MusicGeneration
//
//  Created by Alex Ling on 17/10/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

typedef NSString* MusicType;
#define MusicTypeCelesta @"celesta"
#define MusicTypeClav @"clav"
#define MusicTypeSwells @"swells"

#define MusicCount @{@"celesta": @(27), @"clav": @(27), @"swells": @(3)}

@interface Music : NSObject

@property (strong, nonatomic) MusicType type;

- (instancetype)initWithType: (MusicType) type;
- (void)playWithPitch: (CGFloat) pitch;
+ (void)playType: (MusicType) type withPitch: (CGFloat) pitch;

@end
