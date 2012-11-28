//
//  ToneGenerator.m
//  Paula
//
//  Created by Grant Damron on 10/11/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//


/*
 
 TODO:
 - Allow game to add multiple insances of the same instrument type
 - Figure out how to identify instruments (possible note id)
 - Similarly, figure out how to link tones with instruments
 */


#import "ToneGenerator3.h"
#include "mo_audio.h"
#include "SineWave.h"
#include "Blit.h"
#include "BlitSaw.h"
#include "BlitSquare.h"
#include "Moog.h"
#include "Noise.h"

#define SRATE 44100
#define FRAMESIZE 128
#define NUMCHANNELS 2
#define BUFFER_COUNT    3
#define BUFFER_DURATION 0.5

using namespace stk;

// the instruments we'll use for synthesis
SineWave *sine;
BlitSquare *square;
BlitSaw * saw;
Moog *moog;
Noise *noise;
Blit *blit;

bool g_on = false;
bool instrumentFlags[6];
void audioCallback(Float32 *buffer, UInt32 framesize, void *userData);



@interface ToneGenerator3()

@property NSMutableArray *freqs;
@property NSMutableArray *tones;
@property NSMutableArray *instruments;

@end

@implementation ToneGenerator3

@synthesize isOn;
@synthesize globalGain;
@synthesize waveForm;
@synthesize freqs;
@synthesize tones;
@synthesize instruments;

- (id)init {
    if (self = [super init]) {
        Stk::setRawwavePath("rawwaves");
        freqs = [[NSMutableArray alloc] init];
        tones = [[NSMutableArray alloc] init];
        sine = new SineWave();
        square = new BlitSquare();
        saw = new BlitSaw();
        moog = new Moog();
        noise = new Noise();
        blit = new Blit();
        
    }
    return self;
}

- (void)dealloc {
    delete sine;
    delete square;
    delete saw;
    delete moog;
    delete noise;
    delete blit;
}

- (void)noteOn:(double)freq withGain:(double)g andSoundType:(int)s {
    g_on = YES;
    Tone *tone = [[Tone alloc] init];
    tone.frequency = freq;
    tone.amplitude = g;
    tone.instrument = (enum waveforms) s;
    
    switch (tone.instrument) {
        case sine_wave:
            instrumentFlags[0] = YES;
            sine->setFrequency(tone.frequency);
            break;
            
        case square_wave:
            instrumentFlags[1] = YES;
            square->setFrequency(tone.frequency);
            break;
            
        case saw_wave:
            instrumentFlags[2] = YES;
            saw->setFrequency(tone.frequency);
            break;
            
        case moog_wave:
            instrumentFlags[3] = YES;
            moog->noteOn(tone.frequency, tone.amplitude);
            break;
            
        case noise_wave:
            instrumentFlags[4] = YES;
            break;
            
        case blit_wave:
            instrumentFlags[5] = YES;
            blit->setFrequency(tone.frequency);
            break;
        default:
            break;
    }
}

- (void)noteOff:(double)freq andSoundType:(int)s {
    // not sure this will ever be used
    instrumentFlags[s] = NO;
}

- (void)noteOffWithsoundType:(int)s {
    instrumentFlags[s] = NO;
}

- (void)noteOff:(double) freq {
    [freqs removeObject:[NSNumber numberWithDouble:freq]];
    if (freqs.count>0) {
        //frequency = [[freqs lastObject] doubleValue];
    } else {
        g_on = NO;
        NSLog(@"Note off");
    }
}

- (void)noteOff {
    g_on = NO;
    [freqs removeAllObjects];
    NSLog(@"All notes off");
}

- (void) start {
    NSLog(@"Starting real time audio...");
    if (!(MoAudio::init(SRATE, FRAMESIZE, NUMCHANNELS))) {
        NSLog(@"Cannot initialize real time audio. Exiting.");
    }
    if (!(MoAudio::start(audioCallback, nil))) {
        NSLog(@"Cannot start real time audio.");
    }
}

- (void)stop {
    MoAudio::stop();
    //MoAudio::shutdown();
}


// basic audio callback (C++)
void audioCallback(Float32 *buffer, UInt32 framesize, void *userData) {
    if (!g_on) {
        for (int i = 0; i < framesize; i++) {
            buffer[2*i] = buffer[2*i+1] = 0.0;
        }
    } else {
        for (int i = 0; i < framesize; i ++ ) {
            double num_inst = .001;
            StkFloat sample = 0.0;
            if (instrumentFlags[0]) {
                sample += sine->tick();
                num_inst += 1.0;
            }
            
            if (instrumentFlags[1]) {
                sample += square->tick();
                num_inst += 1.0;
            }
            
            if (instrumentFlags[2]) {
                sample += saw->tick();
                num_inst += 1.0;
            }
            
            if (instrumentFlags[3]) {
                sample += moog->tick();
                num_inst += 1.0;
            }
            
            if (instrumentFlags[4]) {
                sample += noise->tick();
                num_inst += 1;
            }
            
            if (instrumentFlags[5]) {
                sample += blit->tick();
            }
            
            sample /= num_inst;
            // no reverb yet
            //sample = rev->tick(sample);
            
            
			buffer[2*i] = sample;
            buffer[2*i + 1] = sample;
		}
    }
}

@end

@implementation Tone

@synthesize frequency;
@synthesize amplitude;
@synthesize duration;
@synthesize instrument;

@end
