//
//  GK_GameDataHandler.m
//  Paula
//
//  Created by Kevin Tseng on 11/25/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "GK_GameDataHandler.h"

@implementation GK_GameDataHandler

@synthesize uidelegate=_uidelegate;
@synthesize datadelegate=_datadelegate;

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context {
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
    
    short type = [data rw_int16AtOffset:0];
    NSLog(@"packet type = %d", type);
    
    switch (type) {
        case GAME_START:
            if(_uidelegate) {
                [_uidelegate startGame];
//                [_uidelegate setGameMelody:nil];
            }
            break;
        case GAME_SCORE_TO_SERVER:
            if(_datadelegate != nil) {
                short score = [data rw_int16AtOffset:2];
                short mistakes = [data rw_int16AtOffset:4];
                NSLog(@"Score: %d, Mistakes: %d", score, mistakes);
                [_datadelegate trackScores:peerID score:[[NSNumber alloc] initWithShort:score] mistakes:[[NSNumber alloc] initWithShort:mistakes]];
            }
            break;
        case GAME_SCORE_TO_CLIENT:
            if(_datadelegate != nil) {
                size_t count;
                size_t offset = 2;
                short numRecored = [data rw_int16AtOffset:offset];
                offset += 2;
                
                NSMutableArray *players = [[NSMutableArray alloc] initWithCapacity:numRecored];
                for(short i=0; i<numRecored; i++) {
                    Player *p = [[Player alloc] init];
                    p.name = [data rw_stringAtOffset:offset bytesRead:&count];
                    offset += count;
                    short score = [data rw_int16AtOffset:offset];
                    offset += 2;
                    p.score = [[NSNumber alloc] initWithShort:score];
                    short mistakes = [data rw_int16AtOffset:offset];
                    offset += 2;
                    p.mistakesMade = [[NSNumber alloc] initWithShort:mistakes];
                    
                    [players addObject:p];
                }
                
                [_datadelegate receiveScores:players];
            }
            break;
        case GAME_MODE_RETURN_TYPE:
            if(_uidelegate != nil) {
                uint8_t type = [data rw_int8AtOffset:2];
                [_uidelegate setGameMode:type];
            }
            break;
        case GAME_SEND_MELODY:
            if(_datadelegate != nil) {
                [_datadelegate setTurn:peerID];
            }
            if(_uidelegate != nil) {
                uint8_t count = [data rw_int8AtOffset:2];
                int offset = 2;
                NSMutableArray *notes = [[NSMutableArray alloc] initWithCapacity:count];
                for(uint8_t i = 0; i<count; i++) {
                    [notes addObject:[NSNumber numberWithChar:[data rw_int8AtOffset:++offset]]];
                }
                
                NSLog(@"received melody: %@", notes);
                
                [_uidelegate setGameMelody:notes];
            }
            break;
        case GAME_SEND_COMPOSE_MELODY:
            if(_datadelegate != nil) {
                uint8_t count = [data rw_int8AtOffset:2];
                int offset = 2;
                NSMutableArray *notes = [[NSMutableArray alloc] initWithCapacity:count];
                for(uint8_t i = 0; i<count; i++) {
                    [notes addObject:[NSNumber numberWithChar:[data rw_int8AtOffset:++offset]]];
                }
                
                NSLog(@"received composed melody: %@", notes);
                
                if([_datadelegate trackComposedMelody:peerID melody:notes]) {
                    if(_uidelegate != nil) {                        
                        [_uidelegate showPlayButton];
                    }
                }
            }
        case GAME_CHANGE_TURNSTATE:
            if(_uidelegate != nil) {
                
            }
        default:
            NSLog(@"something went wrong, no data received!");
    }
}

@end
