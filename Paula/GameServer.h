//
//  GameServer.h
//  Paula
//
//  Created by Kevin Tseng on 10/17/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameServerDelegate.h"

NSString * const GameServerErrorDomain;
static NSString* _broadcastName = @"Paula";

typedef enum {
    GameServerCouldNotBindToIPv4Address = 1,
    GameServerCouldNotBindToIPv6Address = 2,
    GameServerNoSocketsAvailable = 3,
} GameServerErrorCode;

@interface GameServer : NSObject <NSNetServiceDelegate> {
    @private
    id _serverDelegate;
    uint16_t _port;
    CFSocketRef socketRef;
    NSNetService* _netService;
}

- (BOOL) startServer:(NSError **)error;
- (BOOL) stopServer;
- (BOOL) enableBonjour:(NSString*)domain appProtocol:(NSString*)appProtocol name:(NSString*)name;
- (void) disableBonjour;
@end
