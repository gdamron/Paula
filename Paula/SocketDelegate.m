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
@property (strong, nonatomic, retain) NSInputStream *_inStream;
@property (strong, nonatomic, retain) NSOutputStream *_outStream;
@property (nonatomic) GameServer *server;
@property (nonatomic) NSMutableData *data;

@property (retain) GrantViewController *grantController;
@end

@implementation SocketDelegate

@synthesize grantController;

- (id)init {
    self.data = [[NSMutableData alloc] init];
    return self;
}

- (void) setController:(GrantViewController*) controller {
    self.grantController = controller;
}

@end

@implementation SocketDelegate (GameServerDelegate)

- (void) test {
    NSLog(@"TEST");
}

- (void) acceptConnection:(GameServer *)server inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr {
    self.server = server;
    self._inStream = istr;
    self._outStream = ostr;
    [self openStreams];
}

- (void) openStreams {
	self._inStream.delegate = self;
	[self._inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self._inStream open];
	self._outStream.delegate = self;
	[self._outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[self._outStream open];
}

@end

@implementation SocketDelegate (NSStreamDelegate)

- (void) stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    NSLog(@"NSSTREAM DELEGATE CALLED");
    switch(eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"IN OUT STREAM READY");
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            NSLog(@"reading...");
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
                        reset = YES;
                    }
                    
                    if(reset == NO) {
                        [self.data appendBytes:byte length:length];
                        
                        int note = [[[NSString alloc] initWithBytes:self.data.bytes length:self.data.length encoding:NSASCIIStringEncoding] intValue];
                        
                        if(note == 0) {
                            [self.grantController noteOff];
                        } else {
                            [self.grantController playNote:note];
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
        }
    }
}

@end
