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

@property (assign, nonatomic) BOOL isPaulasTurn;
@property (strong, nonatomic) NSMutableArray *currentRound;

@end

#pragma mark - Implementation
@implementation Game

@synthesize date, score, level, player, paula, currentRound, isPaulasTurn, mode;

- (id)init
{
    self = [super init];
    if (self) {
        score = [NSNumber numberWithDouble:0.0];
        date = [NSDate date];
        level = [[Level alloc] init];
        level.date = self.date;
        player = [[Player alloc] init];
        isPaulasTurn = YES;
        currentRound = [[NSMutableArray alloc] init];
        mode = SINGLE_PLAYER;
    }
    return self;
}

- (id)initWithGameMode:(enum gameModes)m {
    self = [self init];
    mode = m;
    return self;
}

- (void)makePaulasTurn {
    isPaulasTurn = YES;
}

- (void)makePlayersTurn {
    isPaulasTurn = NO;
}

- (BOOL)isPaulasTurn {
    return isPaulasTurn;
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
        score = [NSNumber numberWithInt:[score intValue]+5];
    }
    
    if (player.currentInput.count==currentRound.count) {
        [player.currentInput removeAllObjects];
        if (mistakesWereMade)
            player.mistakesMade = [NSNumber numberWithInt:([player.mistakesMade intValue] + 1)];
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
    
    
    if ([player.mistakesMade intValue] > [player.mistakesAllowed intValue]) {
        NSLog(@"Game Over");
        retval = 2;
    } else if (currentRound.count == numNotesInLayer) {
        NSLog(@"Game Over");
        retval = 3;
    }
    if (retval==0)
        NSLog(@"Player's Turn");
    
    return retval;
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
        currentInput = [[NSMutableArray alloc] init];
        score = [NSNumber numberWithDouble:0.0];
        mistakesAllowed = [NSNumber numberWithInt:5];
        mistakesMade = [NSNumber numberWithInt:0];
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
    currentInput = [NSArray arrayWithArray:temp];
}

@end

#pragma mark - Level Class
#pragma mark - Implementation
@implementation Level

@synthesize score, date, tempo, order, sections;

- (id)init
{
    self = [super init];
    if (self) {
        score = [NSNumber numberWithDouble:0.0];
        date = [NSDate date];
    }
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
    sections = [NSArray arrayWithArray:temp];
    
    NSMutableArray *temp2 = [[NSMutableArray alloc] initWithArray:order];
    [temp2 addObject:[NSNumber numberWithInt:temp2.count-1]];
    order = [NSArray arrayWithArray:temp2];
}

@end

#pragma mark - Section Class
#pragma mark - Implementation
@implementation Section

@synthesize layers, order;

//
//  addLayer
//
//  add layer to end of layers arrat
//
- (void) addLayer:(Layer *)layer {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:layers];
    [temp addObject:layer];
    layers = [NSArray arrayWithArray:temp];
    
    NSMutableArray *temp2 = [[NSMutableArray alloc] initWithArray:order];
    [temp2 addObject:[NSNumber numberWithInt:temp2.count-1]];
    order = [NSArray arrayWithArray:temp2];
}

@end

#pragma mark - Layer Class
#pragma mark - Implementation
@implementation Layer

@synthesize notes, instrument, scale, currentNote, currentStopIndex;

- (id)init
{
    self = [super init];
    if (self) {
        notes = [[NSArray alloc] init];
        instrument = [[Instrument alloc] init];
        scale = [[NSArray alloc] init];
        currentNote = [NSNumber numberWithInt:0];
        currentStopIndex = [NSNumber numberWithInt:1];
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
