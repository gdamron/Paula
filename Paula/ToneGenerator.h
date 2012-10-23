//
//  ToneGenerator.h
//  Paula
//
//  Created by Grant Damron on 10/11/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToneGenerator : NSObject

- (void)noteOn:(double)freq withGain:(double)g andSoundType:(int)s;
- (void)noteOff:(double)freq;
- (void)noteOff;

@end
