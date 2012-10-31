//
//  SocketDelegate.m
//  Paula
//
//  Created by Kevin Tseng on 10/20/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "GameServer.h"
#import "SocketDelegate.h"

@interface SocketDelegate ()
@property (strong, nonatomic) NSInputStream *_inStream;
@property (strong, nonatomic) NSOutputStream *_outStream;
@property (nonatomic) GameServer *server;
@property (nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSNetService *currentResolve;

@property (retain) GrantViewController *grantController;
@property (retain) KevinViewController *kevinController;
@end

@implementation SocketDelegate

@synthesize grantController;

- (id)init {
    self.data = [[NSMutableData alloc] init];
    return self;
}

- (void) setGController:(GrantViewController*) controller {
    self.grantController = controller;
}

- (void) setKController:(KevinViewController *)controller {
    self.kevinController = controller;
}

@end

@implementation SocketDelegate (GameServerDelegate)

- (void) acceptConnection:(GameServer *)server inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr {
    self.server = server;
    self._inStream = istr;
    self._outStream = ostr;
    [self openStreams];
}

- (void) resolveInstance:(NSNetService *)netService {
    NSLog(@"instance resolving...");
	if(netService) {
        self.currentResolve = netService;
        NSLog(@"resolving service: %@", [netService name]);
        [self.currentResolve setDelegate:self];
        [self.currentResolve resolveWithTimeout:1.0];
    }
}

- (void) didResolveInstance:(NSNetService *)netService {
    NSInputStream *inStream;
    NSOutputStream *outStream;
    
    if (![netService getInputStream:&inStream outputStream:&outStream]) {
        NSLog(@"failed to connect to game server");
        return;
    } else {
        self._inStream = inStream;
        self._outStream = outStream;
        [self openStreams];
    }
}

- (void) openStreams {
    NSLog(@"opening actual streams now...");
	self._inStream.delegate = self;
	[self._inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self._inStream open];
	self._outStream.delegate = self;
	[self._outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self._outStream open];
}

- (void) closeStream {
    self.server = nil;
    
    [self._inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self._inStream = nil;
    
    [self._outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self._outStream = nil;
}

@end

@implementation SocketDelegate (NSStreamDelegate)

- (void) send:(const uint8_t)message {
    NSLog(@"sending : %d", message);
	if (self._outStream && [self._outStream hasSpaceAvailable]) {
		if([self._outStream write:(const uint8_t *)&message maxLength:sizeof(const uint8_t)] == -1) {
            NSLog(@"failed sending msg");
        } else {
            uint8_t end = '\n';
            [self._outStream write:(const uint8_t *)&end maxLength:sizeof(const uint8_t)];
            NSLog(@"msg sent %d", message);
        }
    }
}

- (void) stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    NSLog(@"NSSTREAM DELEGATE CALLED");
    switch(eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"IN OUT STREAM READY");
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            if(stream == self._inStream) {
                uint8_t byte[1];
                int length = 0;
                
                length = [self._inStream read:byte maxLength:sizeof(uint8_t)];
                if(length <= 0) {
                    if([stream streamStatus] != NSStreamStatusAtEnd) {
                        NSLog(@"something went wrong");
                    }
                } else {
                    BOOL reset = NO;
                    if(byte[0] == '\n') {
                        NSString *m = [[NSString alloc] initWithBytes:self.data.bytes length:self.data.length encoding:NSASCIIStringEncoding];
                        NSLog(@"%@", m);
                        NSLog(@"newline read");
                        reset = YES;
                    }
                    
                    if(reset == NO) {
                        [self.data appendBytes:byte length:length];
                        
                        int note = [[[NSString alloc] initWithBytes:self.data.bytes length:self.data.length encoding:NSASCIIStringEncoding] intValue];
                        
                        NSLog(@"reading...%d", note);
                        
                        if(note == 0) {
                            if(self.grantController != nil) {
                                [self.grantController playNoteOff];
                            } else if (self.kevinController != nil) {
                                [self.kevinController playNoteOff];
                            }
                        } else {
                            if(self.grantController != nil) {
                                NSLog(@"calling grant");
                                [self.grantController playNote:note];
                            } else if (self.kevinController != nil) {
                                NSLog(@"calling kevin");
                                [self.kevinController playNote:note];
                            }
                        }
                    } else {
                        [self.data setLength:0];
                    }
                }
            }
            break;
        }
        case NSStreamEventErrorOccurred: {
            NSLog(@"serious error occured");
            break;
        }
        case NSStreamEventEndEncountered: {
            NSLog(@"disconncted");
            [self closeStream];
        }
    }
}

@end

@implementation SocketDelegate (NSNetServiceDelegate)
- (void)netServiceWillResolve:(NSNetService *)sender {
    NSLog(@"resolving........");
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    NSLog(@"resolve completed....");
    [self didResolveInstance:sender];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"unable to resolve......");
}

@end
