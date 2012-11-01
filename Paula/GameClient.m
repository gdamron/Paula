//
//  GameClient.m
//  Paula
//
//  Created by Kevin Tseng on 10/30/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "GameClient.h"
#import "SocketDelegate.h"

@interface GameClient ()
@property (strong, nonatomic) SocketDelegate *socketDelegate;
@property (strong) NSNetServiceBrowser *browser;
@end

@implementation GameClient

- (id) initWithController:(GrantViewController*) controller {
    NSNetServiceBrowser *serviceBrowser = [[NSNetServiceBrowser alloc] init];
    
    if(serviceBrowser) {
        self.socketDelegate = [[SocketDelegate alloc] init];
        [self.socketDelegate setController:controller];
        
        NSLog(@"net service browser initialized");
        serviceBrowser.delegate = self;
        self.browser = serviceBrowser;
        NSLog(@"call to searchForServicesOfType");
        
        NSString *bonjourName = [NSString stringWithFormat:@"_%@._tcp.", _broadcastName];
        
        NSLog(@"Search String: %@", bonjourName);
        
        [self.browser searchForServicesOfType:bonjourName inDomain:@"local"];
    } else {
        NSLog(@"Bonjour browser failed");
    }
    
    return self;
}

- (id) getSocketDelegate {
    return self.socketDelegate;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    
    NSLog(@"service browser found service %c", moreComing);
    
    NSLog(@"%@", service.name);
    
    NSLog(@"connecting to server...");
    [self.socketDelegate resolveInstance:service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog(@"domain found");
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    NSLog(@"will search bonjour service");
}

@end
