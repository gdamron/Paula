//
//  GK_GameDataHandler.h
//  Paula
//
//  Created by Kevin Tseng on 11/25/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "NSMutableData+GK_DataAddOn.h"
#import "GK_GameComm.h"
#import "GK_GamePacket.h"
#import "Game.h"

@interface GK_GameDataHandler : NSObject <GKSessionDelegate>

@property (nonatomic, assign) id<GK_GameCommDelegate> uidelegate;
@property (nonatomic, assign) id<GK_GameDataDelegate> datadelegate;

@end
