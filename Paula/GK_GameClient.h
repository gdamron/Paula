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

@interface GK_GameClient : NSObject <GKSessionDelegate>

@property (nonatomic, assign) id<GK_GameCommDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *availableServers;
@property (nonatomic, strong, readonly) GKSession *session;

- (void)startSearchServerForSessionID:(NSString *)sessionID;

@end
