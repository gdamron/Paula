//
//  Game.h
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <Foundation/Foundation.h>

enum gameModes {
    SINGLE_PLAYER = 0,
    MULTI_BASIC = 1,
    MULTI_CHALLENGE = 2,
    MULTI_COOP = 3,
    MULTI_RACE = 4,
    CREATE = 5
    };

@interface Instrument : NSObject

@property (strong, nonatomic) NSNumber *waveform;
@property (strong, nonatomic) NSNumber *lowPitch;
@property (strong, nonatomic) NSNumber *highPitch;

@end

@interface Note : NSObject

@property (strong, nonatomic) NSNumber *degree;
@property (strong, nonatomic) NSNumber *duration;


@end

@interface Layer : NSObject

@property (strong, nonatomic) NSArray *notes;
@property (strong, nonatomic) Instrument *instrument;
@property (strong, nonatomic) NSArray *scale;
@property (strong, nonatomic) NSNumber *currentNote;

@end

@interface Section : NSObject

@property (strong, nonatomic) NSArray *layers;
@property (strong, nonatomic) NSArray *order;
@property (strong, nonatomic) NSNumber *currentLayer;

- (void)addLayer:(Layer *)layer;

@end

@interface Song : NSObject

@property (strong, nonatomic) NSNumber *tempo;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *order;
@property (strong, nonatomic) NSNumber *currentSection;

- (void)addSection:(Section *)section;

@end

@interface Level : NSObject

@property (strong, nonatomic) Song *song;
@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) NSDate *date;


@end

@interface Player : NSObject

@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) NSNumber *mistakesMade;
@property (strong, nonatomic) NSNumber *mistakesAllowed;
@property (strong, nonatomic) NSArray *currentInput;


@end

@interface Game : NSObject

@property (strong, nonatomic) Level *level;
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray *currentRound;

@end
