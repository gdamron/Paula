//
//  ToneGenerator.m
//  Paula
//
//  Created by Grant Damron on 10/11/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "ToneGenerator.h"
#import "momu/mo_audio.h"

#define SRATE 44100
#define FRAMESIZE 128
#define NUMCHANNELS 2
#define BUFFER_COUNT    3
#define BUFFER_DURATION 0.5

bool g_on = false;
double frequency = 0.0;
double gain = 0.0;
int sound_type = 0;
void audioCallback(Float32 *buffer, UInt32 framesize, void *userData);
void sineCallback(Float32 *buffer, UInt32 framesize, void *userData);
void squareCallback(Float32 *buffer, UInt32 framesize, void *userData);
void noiseCallback(Float32 *buffer, UInt32 framesize, void *userData);


@interface ToneGenerator() {
    NSMutableArray *freqs;
}

@end

@implementation ToneGenerator

@synthesize isOn;
@synthesize globalGain;
@synthesize waveForm;

- (id)init {
    if (self = [super init]) {
        freqs = [[NSMutableArray alloc] init];
        NSLog(@"Starting real time audio...");
        if (!(MoAudio::init(SRATE, FRAMESIZE, NUMCHANNELS))) {
            NSLog(@"Cannot initialize real time audio. Exiting.");
            return nil;
        }
        
        if (!(MoAudio::start(audioCallback, nil))) {
            NSLog(@"Cannot start real time audio. Exiting.");
            return nil;
        }
    }
    return self;
}

- (void)noteOn:(double)freq withGain:(double)g andSoundType:(int)s{
    [freqs addObject:[NSNumber numberWithDouble:freq]];
    frequency = freq;
    gain = g;
    sound_type = s;
    g_on = YES;
    
    NSLog(@"Note on: %f", frequency);
}

- (void)noteOff:(double) freq {
    [freqs removeObject:[NSNumber numberWithDouble:freq]];
    if (freqs.count>0) {
        frequency = [[freqs lastObject] doubleValue];
    } else {
        g_on = NO;
        NSLog(@"Note off");
    }
}

- (void)noteOff {
    g_on = NO;
    NSLog(@"Note off");
}


- (void) stop {
    //MoAudio::stop();
    MoAudio::shutdown();
}

@end

// basic audio callback (C++)
void audioCallback(Float32 *buffer, UInt32 framesize, void *userData) {
    if (!g_on) {
        for (int i = 0; i < framesize; i++) {
            buffer[2*i] = buffer[2*i+1] = 0.0;
        }
    } else {
        switch (sound_type) {
            case 0:
                sineCallback(buffer, framesize, userData);
                break;
            case 1:
                squareCallback(buffer, framesize, userData);
                break;
            case 2:
                noiseCallback(buffer, framesize, userData);
                break;
                
            default:
                sineCallback(buffer, framesize, userData);
        }
    }
}

// sine callback (C++) that may be called within audioCallback
void sineCallback(Float32 *buffer, UInt32 framesize, void *userData) {
    static float phase = frequency/SRATE;
    for (int i = 0; i < framesize; i++) {
        buffer[2*i] = buffer[2*i+1] = gain*sin(2.0*M_PI*phase);
        phase += frequency/((double)SRATE);
        if (phase > 1.0f) phase -= 1.0f;
    }
}

// square callback (C++) possibly called within audioCallback
void squareCallback(Float32 *buffer, UInt32 framesize, void *userData) {
    static float phase = frequency/SRATE;
    for (int i = 0; i < framesize; i++) {
        buffer[2*i] = buffer[2*i+1] = (gain*sin(2.0*M_PI*phase) > 0);
        phase += frequency/((double)SRATE);
        if (phase > 1.0f) phase -= 1.0f;
    }
}

// noise callback (C++) possibly called within audioCallback
void noiseCallback(Float32 *buffer, UInt32 framesize, void *userData) {
    static float phase = frequency/SRATE;
    for (int i = 0; i < framesize; i++) {
        buffer[2*i] = buffer[2*i+1] = (rand()%1000)/1000.0;
        phase += frequency/((double)SRATE);
        if (phase > 1.0f) phase -= 1.0f;
    }
}

/*@implementation Tone

@synthesize frequency;
@synthesize phase;
@synthesize j;
@synthesize cycleLength;
@synthesize sample;

@end*/