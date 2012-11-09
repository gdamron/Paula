//
//  SocketDelegate.h
//  Paula
//
//  Created by Kevin Tseng on 10/20/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "GameServer.h"

@interface SocketDelegate : NSObject <NSStreamDelegate, GameServerDelegate, NSNetServiceDelegate> {
    NSInputStream *_inStream;
    NSOutputStream *_outStream;
}

@property(assign) id<GameCommunicationDelegate> controller;

@end
