//
//  Game.m
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize date, score, level, player, currentRound, isPaulasTurn, mode;

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

// returns 0 = continue, 1 = paula's turn, or 2 = game over
- (int)addNoteAndCompare:(int)tile {
    NSLog(@"0");
    int retval = 0;
    [player.currentInput addObject:[NSNumber numberWithInt:tile]];
    BOOL mistakes = [self checkMistakesInInput];
    if (!mistakes) {
        score = [NSNumber numberWithInt:[score intValue]+5];
    }
    
    if (player.currentInput.count==currentRound.count) {
        [player.currentInput removeAllObjects];
        if (mistakes)
            player.mistakesMade = [NSNumber numberWithInt:([player.mistakesMade intValue] + 1)];
        NSLog(@"1");
        retval = 1;
    }
    
    // this is a problem -- number of notes in layer and number of notes stored in round
    // may not match because 0's (rests) are not stored
    Section *currentSection = self.level.song.sections[[self.level.song.currentSection intValue]];
    Layer *currentLayer = currentSection.layers[[currentSection.currentLayer intValue]];
    int numNotesInLayer = 0;
    
    for (int i = 0; i < currentLayer.notes.count; i++) {
        if ([currentLayer.notes[i] intValue]!=0)
            numNotesInLayer++;
        NSLog(@"%d %d", numNotesInLayer, currentRound.count);
    }
    
    
    if ([player.mistakesMade intValue] > [player.mistakesAllowed intValue]) {
        NSLog(@"2");
        retval = 2;
    } else if (currentRound.count == numNotesInLayer) {
        NSLog(@"3");
        retval = 3;
    }
    
    //NSLog(@"mistakes = @d, allowed = %d, retval = %d", retval);
    return retval;
}

- (BOOL)checkMistakesInInput {
    BOOL mistakes = NO;
    for (int i = 0; i < player.currentInput.count; i++) {
        int playerInput = [player.currentInput[i] intValue];
        int paulaInput = [currentRound[i] intValue];
        NSLog(@"player: %d paula: %d count: %d", playerInput, paulaInput, player.currentInput.count);
        if (playerInput!=paulaInput) mistakes=YES;
        else score = [NSNumber numberWithInt:[score intValue]+1];
    }
    //NSLog(@"%@ || %@", player.currentInput, currentRound);
    //NSLog(@"input size: %d round size %d mistakes %d", player.currentInput.count, currentRound.count, mistakes);
    return mistakes;
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
        mistakesAllowed = [NSNumber numberWithInt:5];
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
