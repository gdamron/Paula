//
//  ToneDelegate.h
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ToneDelegate <NSObject>

- (void) playNote:(NSInteger)num;
- (void) playNoteOff;

@end
