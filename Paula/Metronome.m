//
//  Metronome.m
//  Paula
//
//  Created by Grant Damron on 10/26/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Metronome.h"
#import <AudioToolbox/AudioToolbox.h>

#pragma mark - Metronome Class
#pragma mark - Private Interface
@interface Metronome ()

@property (strong, nonatomic) NSDate *startTime;
@property (assign, nonatomic) NSTimeInterval elapsedTime;
@property (assign, nonatomic) BOOL isOn;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) SystemSoundID clickSound;

@end

#pragma mark - Implementation
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
@synthesize notification;

- (id)init {
    self = [super init];
    if (self) {
        isOn = NO;
        clickIsOn = NO;
        bpm = 0.0;
        beatDuration = 0.0;
        beatCount = 0;
        beatResolution = 1;
        notification = @"metronomeClick";
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

//
//  turnOn
//
//  Turn on with last used tempo.
//
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

//
//  turnOnWithBPM
//
//  Turn on with new tempo.
//
- (void)turnOnWithBPM:(double)tempo {
    bpm = tempo;
    beatDuration = 60.0/bpm/beatResolution;
    [self turnOn];
}

//
//  turnOnWithBPM:AndResolution
//
//  Turn on with new tempo and specify how to divide the beat.
//
- (void)turnOnWithBPM:(double)tempo AndResolution:(int)res {
    bpm = tempo;
    beatResolution = res;
    beatDuration = 60.0/bpm/beatResolution;
    [self turnOn];
}

//
//  turnOnWithNotification
//
//  Define a new notification for the metronome to send and turn on.
//
- (void)turnOnWithNotification:(NSString *)notice {
    notification = [NSString stringWithString:notice];
    [self turnOn];
}

//
//  turnOff
//
//  no surprises here
//
- (void)turnOff {
    isOn = NO;
    [timer invalidate];
}

//
//  click
//
//  Advance the beat.  If click sound is turned on, play it.  Send any appropriate
//  notification as well.
//
- (void)click {
    beatCount++;
    currentBeat = elapsedTime;
    elapsedTime = beatCount*beatDuration;
    if (clickIsOn) {
        // play click sound (doesn't seem to work)
        AudioServicesPlaySystemSound(clickSound);
        //NSLog(@"beat start: %f | beat end: %f | beat count: %d", currentBeat, elapsedTime, beatCount);
    }
    NSNotification *notice = [NSNotification notificationWithName:notification object:self];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

//
//  setBPM
//
//  Set new tempo.
//
- (void)setBpm:(double)tempo {
    bpm = tempo;
    beatDuration = 60.0/bpm;
}

//
//  setBeatResolution
//
//  Define how beat is to be divided.
//
- (void)setBeatResolution:(NSInteger)res {
    beatResolution = res;
    beatDuration = 60.0/bpm/beatResolution;
}

// not useful now, but can send custom data the the target
- (NSDictionary *)userInfo {
    return @{@"startTime" : startTime};
}

@end
