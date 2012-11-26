//
//  GK_GameComm.h
//  Paula
//
//  Created by Kevin Tseng on 11/13/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CommErrorType {
    SERVER_DOWN = 0,
    SERVER_FULL = 1,
    NO_NETWORK = 2
};

@protocol GK_GameCommDelegate <NSObject>
@required
- (void) updateUI:(NSMutableArray *)data;
- (void) connectToServer:(NSInteger)idx;
- (void) disAndReturn:(BOOL)ret error:(enum CommErrorType)error;
- (void) startGame;
- (void) showScore:(NSMutableArray *)data;
@end

@protocol GK_GameDataDelegate <NSObject>
@required
- (NSMutableArray *) getInternalData;
- (void) trackScores:(NSString *)peerID score:(NSNumber *)score mistakes:(NSNumber *)mistakes;
- (void) receiveScores:(NSMutableArray *)players;
@end