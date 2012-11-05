//
//  CountdownViewController.h
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Countdown : NSObject

@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) NSNumber *step;
@property (strong,nonatomic) NSNumber *duration;

- (void) countdownWithTempo:(double)bpm;
- (id)initWithWidth:(double)width AndHeight:(double)height;

@end

@interface GameOver : NSObject

@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIButton *button;

- (id)initWithWidth:(double)width AndHeight:(double)height;
- (void)gameWon:(int)totalScore;
- (void)gameLost;

@end
