//
//  CountdownViewController.m
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Countdown.h"

#pragma mark - Countdown Class
#pragma mark - Private Interface
@interface Countdown ()

@end

#pragma mark - Implementation
@implementation Countdown

@synthesize label,step,duration;

- (id)initWithWidth:(double)width AndHeight:(double)height {
    if (self=[super init]) {
        double r = (arc4random()%11)/10.0;
        double g = (arc4random()%11)/10.0;
        double b = (arc4random()%11)/10.0;
        label = [[UILabel alloc] initWithFrame:CGRectMake(width/2-75, height/2-75, 150, 150)];
        label.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        label.text = @"3";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:72];
        step = [NSNumber numberWithInt:3];
    }
    
    return self;
}

//
//  countdownWithTempo
//
//  start the contdown, intializing it with a tempo
//
- (void) countdownWithTempo:(double)bpm {
    
    duration = [NSNumber numberWithDouble:60.0/bpm];
    [NSTimer scheduledTimerWithTimeInterval:[duration doubleValue]
                                     target:self
                                   selector:@selector(performCountdown:)
                                   userInfo:nil
                                    repeats:NO];
    
}

//
//  performCountdown
//
//  continue the countdown started in countdownWithTempo
//
- (void)performCountdown:(NSTimer*)timer {
    step = [NSNumber numberWithInt:[step intValue]-1];
    
    if ([step intValue] > 0) {
        label.text = [NSString stringWithFormat: @"%d", [step intValue]];
        [NSTimer scheduledTimerWithTimeInterval:[duration doubleValue]
                                         target:self
                                       selector:@selector(performCountdown:)
                                       userInfo:nil
                                        repeats:NO];
    } else if ([step intValue] == 0) {
        label.text = @"Go!";
        [NSTimer scheduledTimerWithTimeInterval:[duration doubleValue]
                                         target:self
                                       selector:@selector(performCountdown:)
                                       userInfo:nil
                                        repeats:NO];
    } else {
        [label removeFromSuperview];
        
    }
}

@end

#pragma mark - GameOver Class
#pragma mark - Private Interface
@interface GameOver () {
    BOOL won;
}

@end

#pragma mark - Implementation
@implementation GameOver

@synthesize button,label,listenButton;
@synthesize isMultiPlayer;

- (id)initWithWidth:(double)width AndHeight:(double)height {
    if (self=[super init]) {
        
        won = NO;
        
        double r = (arc4random()%11)/10.0;
        double g = MIN((arc4random()%11)/10.0, 0.6);
        double b = (arc4random()%11)/10.0;
        label = [[UILabel alloc] initWithFrame:CGRectMake(width/2-110, height/2-155, 220, 220)];
        label.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.text = @"";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:42];
        
        // the first button, with a variable message
        button = [[UIButton alloc] initWithFrame:CGRectMake(width/2-110, height/2+70, 220, 48)];
        button.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        
        // the button for playback.
        listenButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2+2, height/2+70, 108, 48)];
        listenButton.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        [listenButton setTitle:@"Listen" forState:UIControlStateNormal];
        [listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        listenButton.titleLabel.font = [UIFont systemFontOfSize:24];
        
        //[button addTarget:self action:@selector(gameOverButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

//
//  gameWon
//
//  Congratulate and show score
//  Currently, the only option is to quit
//
- (void)gameWon:(int)totalScore isMultiPlayer:(BOOL)isMulti gameMode:(enum GameModes)mode {
    won = YES;
    label.text = [NSString stringWithFormat:@"Nice Job!\nScore: %d", totalScore];
    //[button setTitle:@"Play Again!" forState:UIControlStateNormal];
    NSString *title = @"Score";
    if(isMulti && mode == MULTI_PLAYER_COMPETE) {
        title = @"Waiting...";
    } else if (isMulti && mode == MULTI_PLAYER_MIMIC) {
        title = @"Continue";
    } else {
        CGRect bFrame = [button frame];
        bFrame.size.width = bFrame.size.width/2 - 2;
        [button setFrame:bFrame];
    }
    [button setTitle:title forState:UIControlStateNormal];
}

//
//  gameLost
//
//  Chastize for losing
//  Currently, the only option is to quit
//
- (void)gameLost:(BOOL)isMulti gameMode:(enum GameModes)mode {
    won = NO;
    label.text = @"You Didn't keep up with Paula";
    NSString *title = @"View Score";
    if(isMulti && mode == MULTI_PLAYER_COMPETE) {
        title = @"Waiting...";
    } else if (isMulti && mode == MULTI_PLAYER_MIMIC) {
        title = @"Continue";
    }
    [button setTitle:title forState:UIControlStateNormal];
}

//
//  layerComplete
//
//  Congratulate, show score, and get ready to move on
//
- (void)layerComplete:(int)totalScore isMultiPlayer:(BOOL)isMulti {
    won = NO;
    label.text = [NSString stringWithFormat:@"Layer Complete.\nScore: %d", totalScore];
    NSString *title = @"Continue";
    if(isMulti) {
        title = @"Waiting...";
    }
    [button setTitle:title forState:UIControlStateNormal];
}

/*- (void)gameOverButtonPressed {
    [button removeFromSuperview];
    [label removeFromSuperview];
    // add a notification later
}*/

@end