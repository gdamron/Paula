//
//  GameClient.h
//  Paula
//
//  Created by Kevin Tseng on 10/30/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GrantViewController.h"

@interface GameClient : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate>

- (id) initWithController:(GrantViewController*) controller;
- (id) getSocketDelegate;

@end
