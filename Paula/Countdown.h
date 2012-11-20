//
//  CountdownViewController.h
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <UIKit/UIKit.h>

//
//  Class: Countdown
//
//  Plays a countdown before the start of a game
//  This should be rebuilt to extend UIView, not NSObject
//
#pragma mark - Countdown Class -
@interface Countdown : UIView

@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) NSNumber *step;
@property (strong,nonatomic) NSNumber *duration;

#pragma mark - Public Methods
- (void) countdownWithTempo:(double)bpm;
- (id)initWithWidth:(double)width AndHeight:(double)height;

@end

//
//  Class: GameOver
//
//  Shows the appropriate message after a game or round ends
//  This should be rebuilt to extend UIView, not NSObject
//
#pragma mark - GameOver Class -
@interface GameOver : UIView

@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIButton *button;

#pragma mark - Public Methods
- (id)initWithWidth:(double)width AndHeight:(double)height;
- (void)gameWon:(int)totalScore;
- (void)gameLost;

@end
