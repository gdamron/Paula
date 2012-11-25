//
//  GK_GamePacket.h
//  Paula
//
//  Created by Kevin Tseng on 11/24/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GAME_START = 0,
    GAME_SCORE = 1
}
CommPacketType;

@interface GK_GamePacket : NSObject

@property (nonatomic, assign) CommPacketType *packetType;

-(id)initWithPacketType:(CommPacketType*)type;
-(id)initWithPacketData:(NSData *)data;
//this should append a header info to the packet
-(NSData *) data;

@end
