//
//  Metronome.h
//  Paula
//
//  Created by Grant Damron on 10/26/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Metronome : NSObject

@property (assign, nonatomic) double bpm;
@property (strong, nonatomic) NSDate *startTime;
@end
