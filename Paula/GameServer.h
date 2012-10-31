//
//  GameServer.h
//  Paula
//
//  Created by Kevin Tseng on 10/17/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

@class GameServer;

@protocol GameServerDelegate <NSObject>
@optional
- (void) acceptConnection:(GameServer*)server inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr;
- (void) openStream;
- (void) closeStream;
- (void) didResolveInstance:(NSNetService *)netService;
@end

#import <Foundation/Foundation.h>

NSString * const GameServerErrorDomain;
static NSString* _broadcastName = @"Paula";

typedef enum {
    GameServerCouldNotBindToIPv4Address = 1,
    GameServerCouldNotBindToIPv6Address = 2,
    GameServerNoSocketsAvailable = 3,
} GameServerErrorCode;

@interface GameServer : NSObject <NSNetServiceDelegate> {
    @private
//    id _delegate;
    uint16_t _port;
    CFSocketRef socketRef;
    NSNetService* _netService;
}
@property(assign) id<GameServerDelegate> delegate;
- (BOOL) startServer:(NSError *)error;
- (BOOL) stopServer;
- (BOOL) enableBonjour:(NSString*)domain appProtocol:(NSString*)appProtocol name:(NSString*)name;
- (void) disableBonjour;
@end
