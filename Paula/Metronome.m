//
//  Metronome.m
//  Paula
//
//  Created by Grant Damron on 10/26/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Metronome.h"
#import <AudioToolbox/AudioToolbox.h>

@interface Metronome ()

@property (strong, nonatomic) NSDate *startTime;
@property (assign, nonatomic) NSTimeInterval elapsedTime;
@property (assign, nonatomic) BOOL isOn;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) SystemSoundID clickSound;

@end

@implementation Metronome

@synthesize bpm;
@synthesize clickIsOn;
@synthesize elapsedTime;
@synthesize isOn;
@synthesize startTime;
@synthesize timer;
@synthesize beatDuration;
@synthesize currentBeat;
@synthesize beatCount;
@synthesize clickSound;
@synthesize beatResolution;

- (id)init {
    self = [super init];
    if (self) {
        isOn = NO;
        clickIsOn = NO;
        bpm = 0.0;
        beatDuration = 0.0;
        beatCount = 0;
        beatResolution = 1;
        NSURL *path = [[NSBundle mainBundle] URLForResource:@"tap" withExtension:@"aif"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) path, &clickSound);
    }
    return self;
}

- (id)initWithBPM:(double)tempo {
    self = [super init];
    if (self) {
        isOn = NO;
        clickIsOn = NO;
        bpm = tempo;
        beatResolution = 1;
        beatDuration = 60.0/bpm/beatResolution;
        beatCount = 0;
    }
    return self;
}

- (id)initWithBPM:(double)tempo AndResolution:(int)res {
    self = [super init];
    if (self) {
        isOn = NO;
        clickIsOn = NO;
        bpm = tempo;
        beatResolution = res;
        beatDuration = 60.0/bpm/beatResolution;
        beatCount = 0;
    }
    return self;
}

- (void)turnOn {
    assert(bpm>0);
    isOn = YES;
    startTime = [NSDate date];
    elapsedTime = 0.0;
    currentBeat = 0.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:beatDuration
                                             target:self
                                           selector:@selector(click)
                                           userInfo:[self userInfo]
                                            repeats:YES];
}

- (void)turnOnWithBPM:(double)tempo {
    bpm = tempo;
    beatDuration = 60.0/bpm/beatResolution;
    isOn = YES;
    startTime = [NSDate date];
    elapsedTime = 0.0;
    currentBeat = 0.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:beatDuration
                                             target:self
                                           selector:@selector(click)
                                           userInfo:[self userInfo]
                                            repeats:YES];
}

- (void)turnOnWithBPM:(double)tempo AndResolution:(int)res {
    bpm = tempo;
    beatResolution = res;
    beatDuration = 60.0/bpm/beatResolution;
    isOn = YES;
    startTime = [NSDate date];
    elapsedTime = 0.0;
    currentBeat = 0.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:beatDuration
                                             target:self
                                           selector:@selector(click)
                                           userInfo:[self userInfo]
                                            repeats:YES];
}

- (void)turnOff {
    isOn = NO;
    [timer invalidate];
}

- (void)click {
    beatCount++;
    currentBeat = elapsedTime;
    elapsedTime = beatCount*beatDuration;
    if (clickIsOn) {
        // play click sound (doesn't seem to work)
        AudioServicesPlaySystemSound(clickSound);
        //NSLog(@"beat start: %f | beat end: %f | beat count: %d", currentBeat, elapsedTime, beatCount);
    }
    NSNotification *notice = [NSNotification notificationWithName:@"metronomeClick" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

- (void)setBpm:(double)tempo {
    bpm = tempo;
    beatDuration = 60.0/bpm;
}

- (void)setBeatResolution:(NSInteger)res {
    beatResolution = res;
    beatDuration = 60.0/bpm/beatResolution;
}

- (NSDictionary *)userInfo {
    return @{@"startTime" : startTime};
}

@end
