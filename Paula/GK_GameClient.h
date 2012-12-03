//
//  GK_GameClient.h
//  Paula
//
//  Created by Kevin Tseng on 11/13/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GK_GameComm.h"
#import "GK_GamePacket.h"
#import "GK_GameDataHandler.h"
#import "Game.h"

@interface GK_GameClient : NSObject <GKSessionDelegate, GK_GameDataDelegate>

@property (nonatomic, assign) id<GK_GameCommDelegate> delegate;
@property (nonatomic, strong) GK_GameDataHandler *dataHandler;

@property (nonatomic, strong, readonly) NSArray *availableServers;
@property (nonatomic, strong, readonly) GKSession *session;

- (void)startSearchServerForSessionID:(NSString *)sessionID;
- (void)connectToServerWithIdx:(NSInteger)idx;
- (void)sendScore:(NSNumber *)score mistakes:(NSNumber *)mistakes;
- (void)disconnectFromServer;
- (void)disconnect;
- (NSString*) getConnectedServerName;

@end
