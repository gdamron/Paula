//
//  GameClient.h
//  Paula
//
//  Created by Kevin Tseng on 10/30/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketDelegate.h"
#import "GrantViewController.h"

@interface GameClient : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate>

@property(assign) id<GameServerDelegate> delegate;

- (id) init;

@end
