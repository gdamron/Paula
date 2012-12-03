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
    
    NSMapTable *_playerTracker;
    NSMapTable *_turnTracker;
    
    GK_GamePacket *packet;
}

@synthesize maxPlayers;
@synthesize session = _session;
@synthesize delegate = _delegate;
@synthesize mode = _mode;

-(id)init {
    self = [super init];
    if(self) {
        self.maxPlayers = 3;
        _connectedPlayers = [NSMutableArray arrayWithCapacity:self.maxPlayers];
        _connectedPlayerNames = [NSMutableArray arrayWithCapacity:self.maxPlayers];
        //initialize player tracker, may need refactoring as this is not the right place for this logic
        _playerTracker = [[NSMapTable alloc] init];
        _turnTracker = [[NSMapTable alloc] init];
        packet = [[GK_GamePacket alloc] initWithPacketType:GAME_START];
        
        self.dataHandler = [[GK_GameDataHandler alloc] init];
    }
    return self;
}

- (void) receiveScores:(NSMutableArray *)players {
        //do nothing for server
}

- (BOOL) storeScoreForCompeteMode:(NSString *)peerID score:(NSNumber *)score mistakes:(NSNumber *)mistakes {
    if([_playerTracker objectForKey:peerID] == nil) {
        Player *player = [[Player alloc] init];
        
        if(![_connectedPlayers containsObject:peerID]) {
            player.name = [_session displayName];
        } else {
            player.name = [_connectedPlayerNames objectAtIndex:[_connectedPlayers indexOfObject:peerID]];
        }
        player.score = score;
        player.mistakesMade = mistakes;
        [_playerTracker setObject:player forKey:peerID];
    }
    
    return ([_playerTracker count] == [_connectedPlayers count] + 1);
}

- (BOOL) storeScoreForMimicMode:(NSString *)peerID score:(NSNumber *)score mistakes:(NSNumber *)mistakes {
    
    if([_playerTracker objectForKey:peerID] == nil) {
        Player *player = [[Player alloc] init];
        
        if(![_connectedPlayers containsObject:peerID]) {
            player.name = [_session displayName];
        } else {
            player.name = [_connectedPlayerNames objectAtIndex:[_connectedPlayers indexOfObject:peerID]];
        }
        player.score = score;
        player.mistakesMade = mistakes;
        [_playerTracker setObject:player forKey:peerID];
    } else {
        Player *player = [_playerTracker objectForKey:peerID];
        player.score = [NSNumber numberWithInt:[player.score intValue]+[score intValue]];
        player.mistakesMade = [NSNumber numberWithInt:[player.mistakesMade intValue]+[mistakes intValue]];;
    }
    
    return ([_turnTracker count] == [_connectedPlayers count] + 1);
}

- (void) setTurn:(NSString *)peerID {
    if(peerID == nil) {
        peerID = [_session peerID];
    }
    [_turnTracker setObject:peerID forKey:peerID];
    
    for(int i=0; i<[_connectedPlayers count]; i++) {
        NSString *peer = [_connectedPlayers objectAtIndex:i];
        
        if([_turnTracker objectForKey:peerID] == nil) {
            [packet setPacketType:GAME_CHANGE_TURNSTATE];
            NSError *error;
            [_session sendData:[packet data] toPeers:[NSArray arrayWithObject:peer] withDataMode:GKSendDataReliable error:&error];
            break;
        }
    }
}

- (void) sendAndShowScore {
    NSEnumerator *enumerator = [_playerTracker objectEnumerator];
    id value;
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    while((value = [enumerator nextObject])) {
        [data addObject:value];
    }
    
    [self sendScoreToAllClients:data];
    [_delegate showScore:data];
    [_playerTracker removeAllObjects];
}

- (void) trackScores:(NSString *)peerID score:(NSNumber *)score mistakes:(NSNumber *)mistakes {
    
    //means self (server) score
    if(peerID == nil) {
        peerID = [_session peerID];
    }
    
    if(_mode == MULTI_PLAYER_COMPETE) {
        if([self storeScoreForCompeteMode:peerID score:score mistakes:mistakes]) {
            [self sendAndShowScore];
        }
    } else if (_mode == MULTI_PLAYER_MIMIC) {
        if([self storeScoreForMimicMode:peerID score:score mistakes:mistakes]) {
            [self sendAndShowScore];
        }
    }
}

- (void) sendScoreToAllClients:(NSMutableArray *)data {
    [packet setPacketType:GAME_SCORE_TO_CLIENT];
    NSMutableData *d = [packet data];
    
    if(data != nil) {
        [d rw_appendInt16:[data count]];
        NSEnumerator *enumerator = [data objectEnumerator];
        id value;
        while((value = [enumerator nextObject])) {
            Player *p = value;
            [d rw_appendString:p.name];
            [d rw_appendInt16:[p.score shortValue]];
            [d rw_appendInt16:[p.mistakesMade shortValue]];
        }
    }
    
    NSError *error;
    if(![_session sendDataToAllPeers:d withDataMode:GKSendDataReliable error:&error]) {
        NSLog(@"unable to send data %@", error);
    }
}

-(void)startAcceptConnectionForSessionID:(NSString *)sessionID {
    _session = [[GKSession alloc] initWithSessionID:sessionID displayName:nil sessionMode:GKSessionModeServer];
    _session.delegate = self;
	_session.available = YES;
    
    [self.dataHandler setUidelegate:_delegate];
    [self.dataHandler setDatadelegate:self];
    [_session setDataReceiveHandler:self.dataHandler withContext:nil];
    NSLog(@"GKSession started");
}

-(void) close {
    [_session disconnectFromAllPeers];
    [_session setAvailable:NO];
    [_session setDelegate:nil];
    _connectedPlayerNames = nil;
    _connectedPlayers = nil;
    _session = nil;
}

-(void) startGame {
    NSLog(@"starting game....");
    NSError *error;
    
    [packet setPacketType:GAME_START];
    [_session sendDataToAllPeers:[packet data] withDataMode:GKSendDataReliable error:&error];
}

-(void) sendMelody:(NSArray *)melody {
    NSLog(@"sending melody : %@", melody);
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
        
        if(![_session sendDataToAllPeers:d withDataMode:GKSendDataReliable error:&error]) {
            NSLog(@"error sending melody - %@", error);
        }
    }
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
                    
                    [packet setPacketType:GAME_MODE_RETURN_TYPE];
                    NSMutableData *d = [packet data];
                    [d rw_appendInt8:self.mode];
                    NSError *error;
                    if(![session sendData:d toPeers:[NSArray arrayWithObject:peerID] withDataMode:GKSendDataReliable error:&error]) {
                        NSLog(@"problem sending mode to peerId: %@", peerID);
                    }
                    
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
	NSLog(@"PaulaServer: connection request from peer %@", peerID);
    if([_connectedPlayers count] < self.maxPlayers) {
        NSError *error;
        if([session acceptConnectionFromPeer:peerID error:&error]) {
            NSLog(@"peer %@ connected", peerID);
        } else {
            NSLog(@"error accepting connection from %@", peerID);
        }
    } else {
        [session denyConnectionFromPeer:peerID];
    }
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	NSLog(@"MatchmakingServer: connection with peer %@ failed %@", peerID, error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"MatchmakingServer: session failed %@", error);
    [self close];
    [self.delegate disAndReturn:YES error:NO_NETWORK];
}

@end
