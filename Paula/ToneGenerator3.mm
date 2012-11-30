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
#define NUM_INSTRUMENTS 6

using namespace stk;

// the instruments we'll use for synthesis
SineWave *sine;
BlitSquare *square;
BlitSaw * saw;
Moog *moog;
Noise *noise;
Blit *blit;

bool g_on = false;
bool instrumentFlags[NUM_INSTRUMENTS];
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
        // using this for polyphony so I don't have to mess with
        // previous functionality
        tones = [[NSMutableArray alloc] init];
        for (int i = 0; i < NUM_INSTRUMENTS; i++)
            [tones addObject:[[NSMutableArray alloc] init]];
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
    
    [tones[s] addObject:[NSNumber numberWithDouble:tone.frequency]];
    instrumentFlags[s] = YES;
    [self setFrequencyForInstrument:tone];
}

- (void)noteOff:(double)freq withSoundType:(int)s {
    // first remove the note from its instrument's stack
    [tones[s] removeObject:[NSNumber numberWithDouble:freq ]];
    
    // check to see if we need to turn the instrument (or
    // all instruments) off
    if (!tones[s]) {
        instrumentFlags[s] = NO;
        BOOL everythingIsOff = YES;
        for (int i = 0; i < NUM_INSTRUMENTS; i++) {
            if (instrumentFlags[i]==YES)
                everythingIsOff = NO;
        }
        if (everythingIsOff)
            g_on = NO;
    // set new frequency for instrument as appropriate
    } else {
        Tone *tone = [[Tone alloc] init];
        tone.frequency = [[tones[s] lastObject] doubleValue];
        tone.instrument = (enum waveforms) s;
        [self setFrequencyForInstrument:tone];
    }
}

- (void)noteOffWithsoundType:(int)s {
    instrumentFlags[s] = NO;
}

- (void)noteOff:(double) freq {
    [tones[2] removeObject:[NSNumber numberWithDouble:freq]];
    if (freqs.count>0) {
        square->setFrequency([[freqs lastObject] doubleValue]);
    } else {
        g_on = NO;
        NSLog(@"Note off");
    }
}

- (void)noteOff {
    g_on = NO;
    for (int i = 0; i < tones.count; i++) {
        if (tones[i]) 
            [tones[i] removeAllObjects];
        instrumentFlags[i] = NO;
    }
    NSLog(@"All notes off");
}

- (void)setFrequencyForInstrument:(Tone *)tone {
    switch (tone.instrument) {
        case sine_wave:
            sine->setFrequency(tone.frequency);
            break;
            
        case square_wave:
            square->setFrequency(tone.frequency);
            break;
            
        case saw_wave:
            saw->setFrequency(tone.frequency);
            break;
            
        case moog_wave:
            moog->noteOn(tone.frequency, tone.amplitude);
            break;
            
        case noise_wave:
            // nothing to do here
            break;
            
        case blit_wave:
            blit->setFrequency(tone.frequency);
            break;
        default:
            break;
    }
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
    g_on = NO;
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
