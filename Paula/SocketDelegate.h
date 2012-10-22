//
//  SocketDelegate.h
//  Paula
//
//  Created by Kevin Tseng on 10/20/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "GameServer.h"
#import "GrantViewController.h"

@interface SocketDelegate : NSObject <NSStreamDelegate, GameServerDelegate>

- (void) setController:(GrantViewController*) controller;

@end
