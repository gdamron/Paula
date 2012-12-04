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
    NSString *_serverName;
    
    GK_GamePacket *packet;
}

@synthesize session = _session;
@synthesize delegate = _delegate;

-(id) init {
    self = [super init];
    if(self) {
        _availableServers = [NSMutableArray arrayWithCapacity:10];
        _availableServerNames = [NSMutableArray arrayWithCapacity:10];
        self.dataHandler = [[GK_GameDataHandler alloc] init];
        
        packet = [[GK_GamePacket alloc] initWithPacketType:GAME_START];
    }
    return self;
}

- (void)startSearchServerForSessionID:(NSString *)sessionID {
	_session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeClient];
	_session.delegate = self;
	_session.available = YES;
    
    [self.dataHandler setUidelegate:_delegate];
    [self.dataHandler setDatadelegate:self];
    [_session setDataReceiveHandler:self.dataHandler withContext:nil];
}

- (void)connectToServerWithIdx:(NSInteger)idx {
    _serverId = [_availableServers objectAtIndex:(int)idx];
    _serverName = [_session displayNameForPeer:_serverId];
    NSLog(@"connecting to %@", _serverId);
    [_session connectToPeer:_serverId withTimeout:_session.disconnectTimeout];
}

#pragma mark - GK_GameDataDelegate
- (NSMutableArray *) getInternalData {
    return _availableServerNames;
}

- (void) receiveScores:(NSMutableArray *)players {
    [_delegate showScore:players];
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
            [self disconnect];
			break;
        default:
            break;
    }
}

- (void) trackScores:(NSString *)peerID score:(NSNumber *)score mistakes:(NSNumber *)mistakes {
        //do nothing
}

-(void) sendMelody:(NSArray *)melody {
    NSError *error;
    [packet setPacketType:GAME_SEND_MELODY];
    
    NSMutableData *d = [packet data];
    if(melody) {
        [d rw_appendInt8:[melody count]];
        NSEnumerator *en = [melody objectEnumerator];
        NSNumber *note;
        while((note = en.nextObject)) {
            [d rw_appendInt8:[note charValue]];
        }
        
        if(![_session sendData:d toPeers:[NSArray arrayWithObject:_serverId] withDataMode:GKSendDataReliable error:&error]) {
            NSLog(@"error sending melody - %@", error);
        }
    }
}

- (void) setTurn:(NSString *)peerID {
    //do nothing
}

- (void) disconnect {
    [_session disconnectFromAllPeers];
	_session.available = NO;
	_session.delegate = nil;
	_session = nil;
    
	_availableServers = nil;
    _availableServerNames = nil;
	_serverId = nil;
}

- (void)disconnectFromServer {
	[_session disconnectFromAllPeers];
	_session.available = NO;
	_session.delegate = nil;
	_session = nil;
    
	_availableServers = nil;
    _availableServerNames = nil;
	_serverId = nil;
    
    [self.delegate disAndReturn:YES error:SERVER_DOWN];
}

- (NSString*) getConnectedServerName {
    if(_serverName) {
        return _serverName;
    }
    return nil;
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	NSLog(@"MatchmakingClient: connection request from peer %@", peerID);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	NSLog(@"MatchmakingClient: connection with peer %@ failed %@", peerID, error);
    [self disconnectFromServer];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"MatchmakingClient: session failed %@", error);
    [self.delegate disAndReturn:YES error:NO_NETWORK];
}

- (void) sendScore:(NSNumber *)score mistakes:(NSNumber *)mistakes {
    [packet setPacketType:GAME_SCORE_TO_SERVER];
    NSMutableData *data = [packet data];
    [data rw_appendInt16:[score shortValue]];
    [data rw_appendInt16:[mistakes shortValue]];
    NSError *error;
    
    if(![_session sendData:data toPeers:[NSArray arrayWithObject:_serverId] withDataMode:GKSendDataReliable error:&error]) {
        NSLog(@"error sending data %@", error);
    }
}

@end
