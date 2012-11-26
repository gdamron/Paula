//
//  ToneGenerator.h
//  Paula
//
//  Created by Grant Damron on 10/11/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <Foundation/Foundation.h>

enum waveforms {
    sine_wave = 0,
    square_wave = 1,
    saw_wave = 2,
    moog_wave = 3,
    noise_wave = 4,
    blit_wave = 5
};

@interface ToneGenerator : NSObject

@property (assign, nonatomic) BOOL isOn;
@property (assign, nonatomic) int waveForm;
@property (assign, nonatomic) double globalGain;

- (void)noteOn:(double)freq withGain:(double)g andSoundType:(int)s;
- (void)noteOff:(double)freq andSoundType:(int)s;
- (void)noteOff:(double)freq;
- (void)noteOffWithsoundType:(int)s;
- (void)noteOff;
- (void)start;
- (void)stop;
- (void)newInstrument:(int)s;

@end

@interface Tone : NSObject

@property (assign, nonatomic) double frequency;
@property (assign, nonatomic) enum waveforms instrument;
@property (assign, nonatomic) double amplitude;
@property (assign, nonatomic) double duration;

@end
