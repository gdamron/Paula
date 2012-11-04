//
//  Game.m
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize date, score, level, player, currentRound;

- (id)init
{
    self = [super init];
    if (self) {
        score = [NSNumber numberWithDouble:0.0];
        date = [NSDate date];
        level = [[Level alloc] init];
        level.date = self.date;
        player = [[Player alloc] init];
    }
    return self;
}

@end

@implementation Player

@synthesize currentInput, score, mistakesAllowed, mistakesMade;

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

@synthesize notes, instrument, scale, currentNote;

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
