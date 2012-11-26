//
//  GK_GamePacket.m
//  Paula
//
//  Created by Kevin Tseng on 11/24/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "GK_GamePacket.h"
#import "NSMutableData+GK_DataAddOn.h"

@implementation GK_GamePacket

@synthesize packetType = _packetType;

-(id)initWithPacketType:(CommPacketType*)type {
    self = [[self class] alloc];
    
    if(self) {
        self.packetType = type;
    }
    
    return self;
}

-(NSMutableData *) data {
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
	[data rw_appendInt16:(short)self.packetType];
    
    return data;
}

@end
