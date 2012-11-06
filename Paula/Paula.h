//
//  Paula.h
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Metronome.h"
//#import "ToneGenerator.h"

@interface Paula : NSObject

@property (assign, nonatomic) double tempo;
@property (assign, nonatomic) double songDuration;
@property (assign, nonatomic) int numLayers;
@property (assign, nonatomic) int numSections;


- (NSArray *)generateRandomLayerWithDuration:(double)dur AndTempo:(double)bpm;
- (NSArray *)generateRandomLayer;
- (id)initWithDuration:(double)dur Tempo:(double)tempo NumberOfLayers:(int)layers AndSections:(int)sections;


@end
