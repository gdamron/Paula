//
//  GK_GameComm.h
//  Paula
//
//  Created by Kevin Tseng on 11/13/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GK_GameCommDelegate <NSObject>

@required
- (void) updateUI:(NSMutableArray *)data;
- (void) connectToServer:(NSInteger)idx;

@end

@protocol GK_GameDataDelegate <NSObject>

@required
- (NSMutableArray *) getInternalData;

@end