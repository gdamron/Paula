//
//  GameServer.m
//  Paula
//
//  Created by Kevin Tseng on 10/17/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <CFNetwork/CFSocketStream.h>

#import "GameServer.h"
#import "SocketDelegate.h"

@interface GameServer ()
@property(retain) NSNetService* netService;
@property(assign) uint16_t port;
@property(nonatomic) CFSocketRef socketRef;
@property(nonatomic) uint32_t protocolType;
@property (nonatomic) NSError *error;

@property (strong, nonatomic) SocketDelegate *socketDelegate;
@end

@implementation GameServer

@synthesize delegate=_delegate, port=_port, netService=_netService;
@synthesize socketRef;
@synthesize error;


- (id) initWithController:(GrantViewController*) controller {
    self.socketDelegate = [[SocketDelegate alloc] init];
    [self.socketDelegate setController:controller];
    [self setDelegate:self.socketDelegate];
    
    BOOL result = [self startServer:error];
    
    NSString *bonjourName = [NSString stringWithFormat:@"_%@._tcp.", _broadcastName];
    
    if(result) {
        NSLog(@"init bonjour with %@", bonjourName);
    }
    if(![self enableBonjour:@"local" appProtocol:bonjourName name:nil]) {
        NSLog(@"bonjour failed");
    }
    
    NSLog(@"Server Started : %d", result);
    
    return self;
}

- (id) getSocketDelegate {
    return self.socketDelegate;
}

- (BOOL) startServer:(NSError *)error {
    
    NSLog(@"Starting Server : ");
    
    CFSocketContext socketCtx = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    self.protocolType = PF_INET6;
    
    self.socketRef = [self createSocket:self.protocolType socketCtx:socketCtx];
    if(self.socketRef == NULL) {
        self.protocolType = PF_INET;
        self.socketRef = [self createSocket:self.protocolType socketCtx:socketCtx];
    }
    
    //if we're still unable to create a socket, stop creating anything
    if(self.socketRef == NULL) {
        [self deallocWithError:error code:GameServerNoSocketsAvailable];
        NSLog(@"Server not started no socket available");
    }
    
    int yes = 1;
    setsockopt(CFSocketGetNative(self.socketRef), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
    
    //we successfully created socket, we'll need to bind address and port to it
    if(self.protocolType == PF_INET6) {
        if(![self setupIP6:error]) return NO;
    } else {
        if(![self setupIP4:error]) return NO;
    }
    
    CFRunLoopRef runLookRef = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, self.socketRef, 0);
    CFRunLoopAddSource(runLookRef, source, kCFRunLoopCommonModes);
    CFRelease(source);
    
    return YES;
}

- (BOOL) setupIP6:(NSError *)error {
    struct sockaddr_in6 address6;
    memset(&address6, 0, sizeof(address6));
    address6.sin6_len = sizeof(address6);
    address6.sin6_family = AF_INET6;
    address6.sin6_port = 0; //we set port 0 here so that it will automatically assign one for us
    address6.sin6_flowinfo = 0;
    address6.sin6_addr = in6addr_any; //this will help us assign addr
    NSData *addr6 = [NSData dataWithBytes:&address6 length:sizeof(address6)];
    
    if(kCFSocketSuccess != CFSocketSetAddress(self.socketRef, (CFDataRef)CFBridgingRetain(addr6))) {
        [self deallocWithError:error code:GameServerCouldNotBindToIPv6Address];
        return NO;
    }
    
    //here, binding succeeded
    NSData *addr = (NSData *)CFBridgingRelease(CFSocketCopyAddress(self.socketRef));
    memcpy(&address6, [addr bytes], [addr length]);
    self.port = ntohs(address6.sin6_port);
    
    return YES;
}

- (BOOL) setupIP4:(NSError *)error {
    struct sockaddr_in address4;
    memset(&address4, 0, sizeof(address4));
    address4.sin_len = sizeof(address4);
    address4.sin_family = AF_INET;
    address4.sin_port = 0;
    address4.sin_addr.s_addr = htonl(INADDR_ANY);
    NSData *addr4 = [NSData dataWithBytes:&address4 length:sizeof(address4)];
    
    if(kCFSocketSuccess != CFSocketSetAddress(self.socketRef, (CFDataRef)CFBridgingRetain(addr4))) {
        [self deallocWithError:error code:GameServerCouldNotBindToIPv4Address];
        return NO;
    }
    
    //here, binding succeeded
    NSData *addr = (NSData *)CFBridgingRelease(CFSocketCopyAddress(self.socketRef));
    memcpy(&address4, [addr bytes], [addr length]);
    self.port = ntohs(address4.sin_port);
    
    NSLog(@"Address: %d", address4.sin_addr.s_addr);
    NSLog(@"Port: %d", self.port);
    
    return YES;
}

- (void) deallocWithError:(NSError *)error code:(GameServerErrorCode)code {
    if(error) {
        error = [[NSError alloc] initWithDomain:GameServerErrorDomain code:code userInfo:nil];
        if(self.socketRef) {
            CFRelease(self.socketRef);
            self.socketRef = NULL;
        }
    }
}

- (CFSocketRef) createSocket:(uint32_t) protocolType socketCtx:(CFSocketContext)socketCtx {
    CFSocketRef ref = CFSocketCreate(kCFAllocatorDefault, protocolType, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, gameServerCallBackFunc, &socketCtx);
    
    return ref;
}

- (void)handleIncomingSocket:(NSData *)addr inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr {
    NSLog(@"handling incoming sockets");
//    (GameServer *)server inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr
    [self.delegate acceptConnection:self inputStream:istr outputStream:ostr];
}

static void gameServerCallBackFunc(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    NSLog(@"CONNECTION ESTABLISHED");
    
    GameServer *server = (__bridge GameServer *)info;
    
    if (kCFSocketAcceptCallBack == type) {
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t namelen = sizeof(name);
        NSData *peer = nil;
        if (0 == getpeername(nativeSocketHandle, (struct sockaddr *)name, &namelen)) {
            peer = [NSData dataWithBytes:name length:namelen];
        }

        CFReadStreamRef readStream = NULL;
		CFWriteStreamRef writeStream = NULL;
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &readStream, &writeStream);
        if (readStream && writeStream) {
            NSLog(@"here");
            CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            
            [server handleIncomingSocket:peer inputStream:(__bridge NSInputStream *)readStream outputStream:(__bridge NSOutputStream *)writeStream];
            NSLog(@"hmmmm");
        } else {
            NSLog(@"here2");
            close(nativeSocketHandle);
        }
        if (readStream) CFRelease(readStream);
        if (writeStream) CFRelease(writeStream);
    }

}

- (BOOL) stopServer {
    [self disableBonjour];
    
    if(self.socketRef) {
        CFSocketInvalidate(self.socketRef);
        CFRelease(self.socketRef);
        self.socketRef = NULL;
    }
    
    return YES;
}

- (BOOL) enableBonjour:(NSString *)domain appProtocol:(NSString *)appProtocol name:(NSString *)name {
    if(![domain length])
        domain = @"";
    if(![name length])
        name = @"";
    
    if(!appProtocol || ![appProtocol length] || self.socketRef == NULL) {
        return NO;
    }
    
    self.netService = [[NSNetService alloc] initWithDomain:domain type:appProtocol name:name port:self.port];
    if(self.netService == nil) {
        return NO;
    }
    
    [self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.netService publish];
    [self.netService setDelegate:self];
    
    NSLog(@"bonjour initialized");
    
    return YES;
}

- (void) disableBonjour {
    if(self.netService) {
        [self.netService stop];
        [self.netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.netService = nil;
    }
}

- (void) netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"Bonjour service did published...%@", sender.name);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
    NSLog(@"Bonjour service did not publish...%@", sender.name);
}

@end
