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
        label = [[UILabel alloc] initWithFrame:CGRectMake(width/2-75, height/2-75, 150, 150)];
        label.backgroundColor = [UIColor colorWithRed:(arc4random()%1000+1)/1000.0
                                                green:(arc4random()%1000+1)/1000.0
                                                 blue:(arc4random()%1000+1)/1000.0
                                                alpha:1.0];
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
