//
//  CountdownViewController.m
//  Paula
//
//  Created by Grant Damron on 11/3/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "Countdown.h"

@interface Countdown ()

@end

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

- (void) countdownWithTempo:(double)bpm {
    
    duration = [NSNumber numberWithDouble:60.0/bpm];
    [NSTimer scheduledTimerWithTimeInterval:[duration doubleValue]
                                     target:self
                                   selector:@selector(performCountdown:)
                                   userInfo:nil
                                    repeats:NO];
    
}

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

@interface GameOver () {
    BOOL won;
}

@end

@implementation GameOver

@synthesize button,label;

- (id)initWithWidth:(double)width AndHeight:(double)height {
    if (self=[super init]) {
        
        won = NO;
        
        double r = (arc4random()%11)/10.0;
        double g = (arc4random()%11)/10.0;
        double b = (arc4random()%11)/10.0;
        label = [[UILabel alloc] initWithFrame:CGRectMake(width/2-110, height/2-155, 220, 220)];
        label.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.text = @"";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:42];
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(width/2-110, height/2+70, 220, 48)];
        button.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:24];
        
        //[button addTarget:self action:@selector(gameOverButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)gameWon:(int)totalScore {
    won = YES;
    label.text = [NSString stringWithFormat:@"Nice Job!\nScore: %d", totalScore];
    //[button setTitle:@"Play Again!" forState:UIControlStateNormal];
    [button setTitle:@"Quit (for now)" forState:UIControlStateNormal];
}

- (void)gameLost {
    won = NO;
    label.text = @"You Didn't keep up with Paula";
    [button setTitle:@"Quit (for now)" forState:UIControlStateNormal];
}

/*- (void)gameOverButtonPressed {
    [button removeFromSuperview];
    [label removeFromSuperview];
    // add a notification later
}*/

@end