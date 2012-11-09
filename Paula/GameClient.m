//
//  GameClient.m
//  Paula
//
//  Created by Kevin Tseng on 10/30/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "GameClient.h"
#import "SearchGameViewController.h"

@interface GameClient ()
//@property (strong, nonatomic) SocketDelegate *socketDelegate;
@property (strong) NSNetServiceBrowser *browser;
@property (strong, nonatomic) NSMutableArray *services;
@property (strong, nonatomic) NSMutableArray *serviceNames;
@end

@implementation GameClient

@synthesize delegate=_delegate;
@synthesize gameController=_gameController;

- (id) init {
    
    NSNetServiceBrowser *serviceBrowser = [[NSNetServiceBrowser alloc] init];
    
    if(serviceBrowser) {
        NSLog(@"net service browser initialized");
        serviceBrowser.delegate = self;
        self.browser = serviceBrowser;
        NSLog(@"call to searchForServicesOfType");
        
        NSString *bonjourName = [NSString stringWithFormat:@"_%@._tcp.", _broadcastName];
        
        NSLog(@"Search String: %@", bonjourName);
        
        [self.browser searchForServicesOfType:bonjourName inDomain:@"local"];
        
        self.services = [[NSMutableArray alloc] initWithCapacity:5];
        self.serviceNames = [[NSMutableArray alloc] initWithCapacity:5];
    } else {
        NSLog(@"Bonjour browser failed");
    }
    
    return self;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    
    NSLog(@"service browser found service %c", moreComing);
    
    NSLog(@"%@", service.name);
    
    NSLog(@"connecting to server...");
    
    [self.services addObject:service];
    [self.serviceNames addObject:service.name];
    NSLog(@"ADDING SERVICE : %d", self.services.count);
    [self.gameController insertGameService:self.serviceNames];
//    [self.delegate resolveInstance:service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
    [self.services removeObject:netService];
    [self.serviceNames removeObject:netService.name];
    [self.gameController insertGameService:self.serviceNames];
}

- (void) connectToService:(NSUInteger*)idx {
    NSNetService *service = [self.services objectAtIndex:*idx];
    [self.delegate resolveInstance:service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog(@"domain found");
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    NSLog(@"will search bonjour service");
}

@end
