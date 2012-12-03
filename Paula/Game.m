//
//  Game.m
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Game.h"

#define DEFAULT_PLAYER_MISTAKES_ALLOWED 1
#define DEFAULT_GAME_TEMPO 100
#define DEFAULT_GAME_DUR 5.0
#define DEFAULT_GAME_LAYERS 3
#define DEFAULT_GAME_SECTIONS 1

#pragma mark - Game Class -
#pragma mark Private Interface

@interface Game ()

@property (assign, nonatomic) BOOL paulasTurn;
@property (strong, nonatomic) NSMutableArray *currentRound;
@property (assign, nonatomic) double tempo;

@end

#pragma mark - Implementation
@implementation Game

@synthesize date, level, player, paula, currentRound, paulasTurn, mode, tempo, state;

- (id)init
{
    self = [super init];
    if (self) {
        self.tempo = DEFAULT_GAME_TEMPO;
        self.date = [NSDate date];
        self.level = [[Level alloc] initWithTempo:self.tempo];
        self.level.date = self.date;
        self.player = [[Player alloc] init];
        self.paulasTurn = YES;
        self.currentRound = [[NSMutableArray alloc] init];
        self.mode = SINGLE_PLAYER;
    }
    return self;
}

- (id)initWithGameMode:(enum GameModes)m {
    self = [self init];
    self.mode = m;
    return self;
}

- (id)initWithTempo:(double)t AndGameMode:(enum GameModes)m {
    self = [self initWithGameMode:m];
    self.tempo = t;
    return self;
}

- (void)makePaulasTurn {
    self.paulasTurn = YES;
}

- (void)makePlayersTurn {
    self.paulasTurn = NO;
}

- (BOOL)isPaulasTurn {
    return self.paulasTurn;
}

- (void)newRound {
    [currentRound removeAllObjects];
}

- (void)addPlayerInput:(int)tile {
    [player.currentInput addObject:[NSNumber numberWithInt:tile]];
}

- (void)addPaulaInput:(int)tile {
    [currentRound addObject:[NSNumber numberWithInt:tile]];
}

- (NSArray *)currentRound {
    return [NSArray arrayWithArray:currentRound];
}

//  
//  rewardOrPenalize
//  
//  removes a mistake if player screwed up, or adds points if there were
//  no mistakes in the round
//
//  returns 0 = continue, 1 = paula's turn, or 2 = game over
//
- (int)rewardOrPenalize:(BOOL)mistakesWereMade {
    int retval = 0;
    if (!mistakesWereMade) {
        self.player.score = [NSNumber numberWithInt:[player.score intValue]+5];
    }
    
    // this is a problem -- number of notes in layer and number of notes stored in round
    // may not match because 0's (rests) are not stored
    Section *currentSection = self.level.sections[[self.level.currentSection intValue]];
    Layer *currentLayer = currentSection.layers[[currentSection.currentLayer intValue]];
    int numNotesInLayer = 0;
    int numSections = level.sections.count;
    int numLayersInSection = currentSection.layers.count;
    
    for (int i = 0; i < currentLayer.notes.count; i++) {
        if ([currentLayer.notes[i] intValue]!=0)
            numNotesInLayer++;
    }
    if (player.currentInput.count == numNotesInLayer
        && [level.currentSection intValue] == numSections-1
        && [currentSection.currentLayer intValue] == numLayersInSection-1) {
        
        [player.currentInput removeAllObjects];
        NSLog(@"Game Won");
        retval = 3;
    
    }   else if (player.currentInput.count == numNotesInLayer) {
        [player.currentInput removeAllObjects];
        NSLog(@"Layer Complete");
        retval = 4;
    } else if (player.currentInput.count==currentRound.count) {
        [player.currentInput removeAllObjects];
        if (mistakesWereMade)
            self.player.mistakesMade = [NSNumber numberWithInt:([player.mistakesMade intValue] + 1)];
        NSLog(@"Paula's Turn");
        retval = 1;
    }
    
    if ([self.player.mistakesMade intValue] > [self.player.mistakesAllowed intValue]) {
        NSLog(@"Game Over");
        retval = 2;
    }
    
    if (retval==0)
        NSLog(@"Player's Turn");
    
    return retval;
}

//
//  generateSimpleLevel
//
//  Creates a 15 second level with 1 section and 3 layers at 80 bpm
//
- (void)generateSimpleLevel {
    self.tempo = DEFAULT_GAME_TEMPO;
    Section *section = [[Section alloc] init];
    for (int i = 0; i < DEFAULT_GAME_LAYERS; i++) {
        Layer *layer = [[Layer alloc] init];
        layer.instrument.lowPitch = [NSNumber numberWithInt: i * 24 + 32];
        // square wave
        layer.instrument.waveform = [NSNumber numberWithInt:1];
        layer.notes = [paula generateRandomLayerWithDuration:DEFAULT_GAME_DUR AndTempo:DEFAULT_GAME_TEMPO];
        [section addLayer:layer];
    }
    
    [self.level addSection:section];

}

@end

#pragma mark - Player Class
#pragma mark - Implementation
@implementation Player

@synthesize currentInput, score, mistakesAllowed, mistakesMade;

- (id)init
{
    self = [super init];
    if (self) {
        self.currentInput = [[NSMutableArray alloc] init];
        self.score = [NSNumber numberWithDouble:0.0];
        self.mistakesAllowed = [NSNumber numberWithInt:DEFAULT_PLAYER_MISTAKES_ALLOWED];
        self.mistakesMade = [NSNumber numberWithInt:0];
    }
    return self;
}

//
//  addNote
//
//  add section to end of currentInput array
//
- (void)addNote:(Note *)note {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:currentInput];
    [temp addObject:note];
    self.currentInput = [NSArray arrayWithArray:temp];
}

@end

#pragma mark - Level Class
#pragma mark - Implementation
@implementation Level

@synthesize score, date, tempo, order, sections, currentSection;

- (id)init
{
    self = [super init];
    if (self) {
        self.score = [NSNumber numberWithDouble:0.0];
        // default tempo is 80 bpm
        self.tempo = [NSNumber numberWithDouble:DEFAULT_GAME_TEMPO];
        self.date = [NSDate date];
        self.sections = [[NSArray alloc] init];
        self.currentSection = [NSNumber numberWithInt:0];
    }
    return self;
}

- (id)initWithTempo:(double)t {
    self = [self init];
    tempo = [NSNumber numberWithDouble:t];
    return self;
}

//
//  addSection
//
//  add section to end of sections array
//
- (void) addSection:(Section *)section {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:sections];
    [temp addObject:section];
    self.sections = [NSArray arrayWithArray:temp];
    
    NSMutableArray *temp2 = [[NSMutableArray alloc] initWithArray:order];
    [temp2 addObject:[NSNumber numberWithInt:temp2.count-1]];
    self.order = [NSArray arrayWithArray:temp2];
}

@end

#pragma mark - Section Class
#pragma mark - Implementation
@implementation Section

@synthesize layers, order, currentLayer;

- (id)init {
    if (self = [super init]) {
        self.layers = [[NSArray alloc] init];
        self.order = [[NSArray alloc] init];
        self.currentLayer = [NSNumber numberWithInt:0];
    }
    
    return self;
}

//
//  addLayer
//
//  add layer to end of layers array
//
- (void) addLayer:(Layer *)layer {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:layers];
    [temp addObject:layer];
    self.layers = [NSArray arrayWithArray:temp];
    
    NSMutableArray *temp2 = [[NSMutableArray alloc] initWithArray:order];
    [temp2 addObject:[NSNumber numberWithInt:temp2.count-1]];
    self.order = [NSArray arrayWithArray:temp2];
}

@end

#pragma mark - Layer Class
#pragma mark - Implementation
@implementation Layer

@synthesize notes, instrument, scale, currentNote, currentStopIndex, beatResolution;

- (id)init
{
    self = [super init];
    if (self) {
        self.notes = [[NSArray alloc] init];
        self.instrument = [[Instrument alloc] init];
        self.scale = [[NSArray alloc] init];
        self.currentNote = [NSNumber numberWithInt:0];
        self.currentStopIndex = [NSNumber numberWithInt:1];
        self.beatResolution = [NSNumber numberWithInt:1];
    }
    return self;
}

//
//  setNotes
//
//  Stores an array of notes in a layer
//
- (void)setNotes:(NSArray *)n {
    notes = [[NSArray alloc] initWithArray:n copyItems:YES];
}

@end

#pragma mark - Instrument Class
#pragma mark - Implementation
@implementation Instrument

@synthesize highPitch, lowPitch, waveform;

@end

#pragma mark - Note Class
#pragma mark - Implementation
@implementation Note

@synthesize degree, duration;

@end
