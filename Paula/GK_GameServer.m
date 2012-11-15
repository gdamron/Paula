//
//  GK_GameServer.m
//  Paula
//
//  Created by Kevin Tseng on 11/13/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "GK_GameServer.h"

@implementation GK_GameServer {
    NSMutableArray *_connectedPlayers;
    NSMutableArray *_connectedPlayerNames;
}

@synthesize maxPlayers;
@synthesize session = _session;
@synthesize delegate = _delegate;

-(void)startAcceptConnectionForSessionID:(NSString *)sessionID {
    self.maxPlayers = 3;
    _connectedPlayers = [NSMutableArray arrayWithCapacity:self.maxPlayers];
    _connectedPlayerNames = [NSMutableArray arrayWithCapacity:self.maxPlayers];
    
    _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeServer];
    _session.delegate = self;
	_session.available = YES;
    
    NSLog(@"GKSession started");
}

-(void) close {
    [_session setAvailable:NO];
}

-(void) startGame {
    NSLog(@"starting game....");
    NSError *error;
    char d = '9';
    NSData *data = [[NSData alloc] initWithBytes:&d length:1];
    [_session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
}

#pragma mark - GK_GameDataDelegate
- (NSMutableArray *) getInternalData {
    return _connectedPlayerNames;
}

#pragma mark - GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	NSLog(@"MatchmakingServer: peer %@ changed state %d", peerID, state);
    
    switch (state)
	{
		case GKPeerStateAvailable:
			break;
            
		case GKPeerStateUnavailable:
			break;
		case GKPeerStateConnected:
				if (![_connectedPlayers containsObject:peerID]) {
					[_connectedPlayers addObject:peerID];
                    [_connectedPlayerNames addObject:[_session displayNameForPeer:peerID]];
                    [self.delegate updateUI:_connectedPlayers];
				}
			break;
		case GKPeerStateDisconnected:
				if ([_connectedPlayers containsObject:peerID]) {
                    int idx = [_connectedPlayers indexOfObject:peerID];
                    [_connectedPlayers removeObject:peerID];
                    [_connectedPlayerNames removeObjectAtIndex:idx];
					[self.delegate updateUI:_connectedPlayers];
				}
			break;
            
		case GKPeerStateConnecting:
			break;
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	NSLog(@"MatchmakingServer: connection request from peer %@", peerID);
    NSError *error;
    if([session acceptConnectionFromPeer:peerID error:&error]) {
        NSLog(@"peer %@ connected", peerID);
    } else {
        NSLog(@"error accepting connection from %@", peerID);
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: connection with peer %@ failed %@", peerID, error);
#endif
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: session failed %@", error);
#endif
}

@end
