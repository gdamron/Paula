//
//  Game.m
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize date, score, level, player, currentRound, isPaulasTurn;

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
    }
    return self;
}

- (BOOL)addNoteAndCompare:(int)tile {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:player.currentInput];
    [temp addObject:[NSNumber numberWithInt:tile]];
    player.currentInput = [NSArray arrayWithArray:temp];
    int playerTile = [[player.currentInput lastObject] intValue];
    int paulaTile = [[currentRound lastObject] intValue];
    
    if (playerTile!=paulaTile)
        player.mistakesMade = [NSNumber numberWithInt:[player.mistakesMade intValue]];
    
    return player.mistakesMade < player.mistakesAllowed;
}

@end

@implementation Player

@synthesize currentInput, score, mistakesAllowed, mistakesMade;

- (id)init
{
    self = [super init];
    if (self) {
        currentInput = [[NSMutableArray alloc] init];
        score = [NSNumber numberWithDouble:0.0];
        mistakesAllowed = [NSNumber numberWithInt:3];
        mistakesMade = [NSNumber numberWithInt:0];
    }
    return self;
}

- (void)addNote:(Note *)note {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:currentInput];
    [temp addObject:note];
    currentInput = [NSArray arrayWithArray:temp];
}

@end

@implementation Level

@synthesize song, score, date;

- (id)init
{
    self = [super init];
    if (self) {
        score = [NSNumber numberWithDouble:0.0];
        date = [NSDate date];
        song = [[Song alloc] init];
    }
    return self;
}

@end

@implementation Song

@synthesize tempo, order, sections;

- (void) addSection:(Section *)section {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:sections];
    [temp addObject:section];
    sections = [NSArray arrayWithArray:temp];
    
    NSMutableArray *temp2 = [[NSMutableArray alloc] initWithArray:order];
    [temp2 addObject:[NSNumber numberWithInt:temp2.count-1]];
    order = [NSArray arrayWithArray:temp2];
}

@end

@implementation Section

@synthesize layers, order;

- (void) addLayer:(Layer *)layer {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:layers];
    [temp addObject:layer];
    layers = [NSArray arrayWithArray:temp];
    
    NSMutableArray *temp2 = [[NSMutableArray alloc] initWithArray:order];
    [temp2 addObject:[NSNumber numberWithInt:temp2.count-1]];
    order = [NSArray arrayWithArray:temp2];
}

@end

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

- (void)setNotes:(NSArray *)n {
    notes = [[NSArray alloc] initWithArray:n copyItems:YES];
}

@end

@implementation Instrument

@synthesize highPitch, lowPitch, waveform;

@end

@implementation Note

@synthesize degree, duration;

@end
