//
//  Metronome.h
//  Paula
//
//  Created by Grant Damron on 10/26/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//  Class: Metronome
//
//  Controls the flow of time
//
#pragma mark - Metronome Class -
@interface Metronome : NSObject

@property (assign, nonatomic) NSTimeInterval currentBeat;
@property (assign, nonatomic) double bpm;
@property (assign, nonatomic) NSTimeInterval beatDuration;
@property (assign, nonatomic) BOOL clickIsOn;
@property (assign, nonatomic) NSInteger beatCount;
@property (assign, nonatomic) NSInteger beatResolution;
@property (strong, nonatomic) NSString *notification;

#pragma mark - Public Methods
- (id)initWithBPM:(double)tempo;
- (id)initWithBPM:(double)tempo AndResolution:(int)res;
- (void)turnOn;
- (void)turnOnWithBPM:(double)tempo;
- (void)turnOnWithBPM:(double)tempo AndResolution:(int)res;
- (void)turnOnWithNotification:(NSString *)notice;
- (void)turnOff;
- (void)click;
//- (void)clickWithEvent;

@end
