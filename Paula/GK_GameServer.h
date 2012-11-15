//
//  GK_GameServer.h
//  Paula
//
//  Created by Kevin Tseng on 11/13/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GK_GameComm.h"

#define SESSION_ID @"Paula"

@interface GK_GameServer : NSObject <GKSessionDelegate, GK_GameDataDelegate>

@property (nonatomic, assign) id<GK_GameCommDelegate> delegate;
@property (nonatomic) int maxPlayers;
@property (nonatomic, strong, readonly) NSArray *connectedPlayers;
@property (nonatomic, strong, readonly) GKSession *session;

- (void) startAcceptConnectionForSessionID:(NSString *)sessionID;
- (void) close;
- (void) startGame;

@end
