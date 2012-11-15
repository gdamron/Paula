//
//  GK_GameClient.m
//  Paula
//
//  Created by Kevin Tseng on 11/13/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "GK_GameClient.h"

@implementation GK_GameClient {
    NSMutableArray *_availableServers;
    NSMutableArray *_availableServerNames;
    
    NSString *_serverId;
}

@synthesize session = _session;
@synthesize delegate = _delegate;

- (void)startSearchServerForSessionID:(NSString *)sessionID {
	_availableServers = [NSMutableArray arrayWithCapacity:10];
    _availableServerNames = [NSMutableArray arrayWithCapacity:10];
    
	_session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
	_session.delegate = self;
	_session.available = YES;
}

- (void)connectToServerWithIdx:(NSInteger)idx {
    _serverId = [_availableServers objectAtIndex:(int)idx];
    NSLog(@"connecting to %@", _serverId);
    [_session connectToPeer:_serverId withTimeout:_session.disconnectTimeout];
}

#pragma mark - GK_GameDataDelegate
- (NSMutableArray *) getInternalData {
    return _availableServerNames;
}

#pragma mark - GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	NSLog(@"Paula: peer %@ changed state %d", peerID, state);
    
    switch (state) {
        case GKPeerStateAvailable:
            if (![_availableServers containsObject:peerID]) {
                [_availableServers addObject:peerID];
                [_availableServerNames addObject:[_session displayNameForPeer:peerID]];
                if (self.delegate != nil) {
                    NSLog(@"server found, updating UI...");
                    [self.delegate updateUI:_availableServerNames];
                }
            }
            break;
        case GKPeerStateUnavailable:
            if ([_availableServers containsObject:peerID]) {
                int idx = [_availableServers indexOfObject:peerID];
                [_availableServers removeObject:peerID];
                [_availableServerNames removeObjectAtIndex:idx];
                if (self.delegate != nil) {
                    [self.delegate updateUI:_availableServerNames];
                }
            }
            break;
		case GKPeerStateConnected:
			break;
		case GKPeerStateDisconnected:
            [self disconnectFromServer];
			break;
        default:
            break;
    }
}

- (void)disconnectFromServer {
	[_session disconnectFromAllPeers];
	_session.available = NO;
	_session.delegate = nil;
	_session = nil;
    
	_availableServers = nil;
    
//	[self.delegate matchmakingClient:self didDisconnectFromServer:_serverPeerID];
	_serverId = nil;
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
#ifdef DEBUG
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: connection request from peer %@", peerID);
#endif
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	NSLog(@"MatchmakingClient: connection with peer %@ failed %@", peerID, error);
    [self disconnectFromServer];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingClient: session failed %@", error);
#endif
}
@end
