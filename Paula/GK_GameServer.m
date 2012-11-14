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
}

@synthesize maxPlayers;
@synthesize session = _session;
@synthesize delegate = _delegate;

-(void)startAcceptConnectionForSessionID:(NSString *)sessionID {
    self.maxPlayers = 3;
    _connectedPlayers = [NSMutableArray arrayWithCapacity:self.maxPlayers];
    
    _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeServer];
    _session.delegate = self;
	_session.available = YES;
    
    NSLog(@"GKSession started");
}

-(void) close {
    [_session setAvailable:NO];
}

#pragma mark - GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: peer %@ changed state %d", peerID, state);
#endif
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"MatchmakingServer: connection request from peer %@", peerID);
#endif
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
