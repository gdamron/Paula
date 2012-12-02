//
//  Game.h
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paula.h"

enum GameModes {
    SINGLE_PLAYER = 0,
    MULTI_PLAYER_COMPETE = 1,
    MULTI_PLAYER_MIMIC = 2,
    MULTI_PLAYER_COMPOSE,
    JUST_PlAY = 4
};

@class Player;
@class Level;
@class Section;
@class Layer;
@class Instrument;
@class Note;

#pragma mark - Game Class -
//
//  Class: Game
//
//  The highes level of the model.  Holds level, player, and
//  an instances of paula
//
@interface Game : NSObject

@property (strong, nonatomic) Level *level;
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) Paula *paula;
@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) enum GameModes mode;

#pragma mark - Public Methods
- (id)initWithGameMode:(enum GameModes)m;
- (id)initWithTempo:(double)t AndGameMode:(enum GameModes)m;
- (void)addPlayerInput:(int)tile;
- (void)addPaulaInput:(int)tile;
- (int)rewardOrPenalize:(BOOL)mistakesWereMade;
- (void)makePlayersTurn;
- (void)makePaulasTurn;
- (BOOL)isPaulasTurn;
- (void)newRound;
- (void)generateSimpleLevel;
- (NSArray *)currentRound;

@end

#pragma mark - Player Class -
//
//  Class: Player
//
//  Represents the player's current actions.  Holds
//  total score for the game, mistakes, and input
//
@interface Player : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) NSNumber *mistakesMade;
@property (strong, nonatomic) NSNumber *mistakesAllowed;
@property (strong, nonatomic) NSMutableArray *currentInput;


@end

#pragma mark - Level Class -
//
//  Class: Level
//
//  Describes the structure of the current level of the game
//
@interface Level : NSObject

@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSNumber *tempo;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *order;
@property (strong, nonatomic) NSNumber *currentSection;

#pragma mark - Public Methods
- (id)initWithTempo:(double)t;
- (void)addSection:(Section *)section;


@end

#pragma mark - Section Class -
//
//  Class: Section
//
//  A collection of layers
//
@interface Section : NSObject

@property (strong, nonatomic) NSArray *layers;
@property (strong, nonatomic) NSArray *order;
@property (strong, nonatomic) NSNumber *currentLayer;
@property (strong, nonatomic) NSArray *currentLayers;

#pragma mark - Public Methods
- (void)addLayer:(Layer *)layer;

@end

#pragma mark - Layer Class -
//
//  Class: Layer
//
//  A melody, current position in the melody, and description of sound type
//
@interface Layer : NSObject

@property (strong, nonatomic) NSArray *notes;
@property (strong, nonatomic) Instrument *instrument;
@property (strong, nonatomic) NSArray *scale;
@property (strong, nonatomic) NSNumber *currentNote;
@property (strong, nonatomic) NSNumber *currentStopIndex;
@property (strong, nonatomic) NSNumber *beatResolution;

@end

#pragma mark - Instrument Class -
//
//  Class: Instrument
//
//  A description of a sound type and its range
//
@interface Instrument : NSObject

@property (strong, nonatomic) NSNumber *waveform;
@property (strong, nonatomic) NSNumber *lowPitch;
@property (strong, nonatomic) NSNumber *highPitch;

@end

#pragma mark - Note Class -
//
//  Class: Note
//
//  A scale degree and a duration
//
@interface Note : NSObject

@property (strong, nonatomic) NSNumber *degree;
@property (strong, nonatomic) NSNumber *duration;


@end
