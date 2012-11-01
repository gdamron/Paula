//
//  SocketDelegate.h
//  Paula
//
//  Created by Kevin Tseng on 10/20/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "GameServer.h"
#import "GrantViewController.h"

@interface SocketDelegate : NSObject <NSStreamDelegate, GameServerDelegate, NSNetServiceDelegate> {
NSInputStream *_inStream;
NSOutputStream *_outStream;
}

- (void) setController:(GrantViewController*) controller;
- (void) didResolveInstance:(NSNetService *)netService;
- (void) resolveInstance:(NSNetService *)netService;
- (void) send:(const uint8_t)message;

@end
