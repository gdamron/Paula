//
//  Game.m
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Game.h"

#pragma mark - Game Class -
#pragma mark Private Interface

@interface Game ()

@property (assign, nonatomic) BOOL paulasTurn;
@property (strong, nonatomic) NSMutableArray *currentRound;
@property (assign, nonatomic) double tempo;

@end

#pragma mark - Implementation
@implementation Game

@synthesize date, level, player, paula, currentRound, paulasTurn, mode, tempo;

- (id)init
{
    self = [super init];
    if (self) {
        self.tempo = 80;
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
    
    if (player.currentInput.count==currentRound.count) {
        [player.currentInput removeAllObjects];
        if (mistakesWereMade)
            self.player.mistakesMade = [NSNumber numberWithInt:([player.mistakesMade intValue] + 1)];
        NSLog(@"Paula's Turn");
        retval = 1;
    }
    
    // this is a problem -- number of notes in layer and number of notes stored in round
    // may not match because 0's (rests) are not stored
    Section *currentSection = self.level.sections[[self.level.currentSection intValue]];
    Layer *currentLayer = currentSection.layers[[currentSection.currentLayer intValue]];
    int numNotesInLayer = 0;
    
    for (int i = 0; i < currentLayer.notes.count; i++) {
        if ([currentLayer.notes[i] intValue]!=0)
            numNotesInLayer++;
        NSLog(@"%d %d", numNotesInLayer, currentRound.count);
    }
    
    
    if ([self.player.mistakesMade intValue] > [self.player.mistakesAllowed intValue]) {
        NSLog(@"Game Over");
        retval = 2;
    } else if (self.currentRound.count == numNotesInLayer) {
        NSLog(@"Game Over");
        retval = 3;
    }
    if (retval==0)
        NSLog(@"Player's Turn");
    
    return retval;
}

//
//  generateNewLevel
//
//  Creates a 15 second level with 1 section and 3 layers at 80 bpm
//
- (void)generateSimpleLevel {
    self.tempo = 80.0;
    Section *section = [[Section alloc] init];
    for (int i = 0; i < 3; i++) {
        Layer *layer = [[Layer alloc] init];
        layer.instrument.lowPitch = [NSNumber numberWithInt: i * 24 + 32];
        // square wave
        layer.instrument.waveform = [NSNumber numberWithInt:1];
        layer.notes = [paula generateRandomLayerWithDuration:15.0 AndTempo:80.0];
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
        self.mistakesAllowed = [NSNumber numberWithInt:1];
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
        self.tempo = [NSNumber numberWithDouble:80.0];
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
