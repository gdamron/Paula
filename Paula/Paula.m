//
//  Paula.m
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Paula.h"

@interface Paula ()

@property (assign,nonatomic) int beatsPerLayer;
@property (assign,nonatomic) double layerDuration, inputDuration, beatDuration;

@end

@implementation Paula

@synthesize numLayers,songDuration,tempo,beatsPerLayer, numSections, layerDuration, beatDuration, inputDuration;

- (id)initWithDuration:(double)dur Tempo:(double)bpm NumberOfLayers:(int)layers AndSections:(int)sec {
    
    if (self = [super init]) {
        inputDuration = dur;
        numLayers = layers;
        numSections = sec;
        tempo = bpm;
        [self calculateBeatsAndDurations];
        
    }
    
    return self;
}

- (NSArray *)generateRandomLayer {
    NSMutableArray *layer = [NSMutableArray arrayWithCapacity:beatsPerLayer];
    // this line should be removed later!
    [layer addObject:[NSNumber numberWithInt:2]];
    for (int i = 1; i < beatsPerLayer-1; i++) {
        int r = arc4random()%9;
        [layer addObject:[NSNumber numberWithInt:r]];
    }
    // this one too!
    [layer addObject:[NSNumber numberWithInt:2]];
    return [NSArray arrayWithArray:layer];
}

- (NSArray *)generateRandomLayerWithDuration:(double)dur AndTempo:(double)bpm {
    inputDuration = dur;
    tempo = bpm;
    [self calculateBeatsAndDurations];
    return [self generateRandomLayer];
}

- (void)setNumSections:(int)numSec {
    self.numSections = numSec;
    [self calculateBeatsAndDurations];
}

- (void)setTempo:(double)bpm {
    self.tempo = bpm;
    [self calculateBeatsAndDurations];
}

- (void)setSongDuration:(double)songDur {
    self.songDuration = songDur;
    [self calculateBeatsAndDurations];
}

- (void)setNumLayers:(int)layers {
    self.numLayers = layers;
    [self calculateBeatsAndDurations];
}

- (void)calculateBeatsAndDurations {
    beatDuration = 60.0/tempo;
    beatsPerLayer = inputDuration/numSections/beatDuration;
    layerDuration = beatDuration * beatsPerLayer;
}

@end
