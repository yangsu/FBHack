//
//  SocketCenter.m
//  FBHack
//
//  Created by Brandon Millman on 10/5/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import "SocketCenter.h"

#import "SRWebSocket.h"

#define kBaseURL @"23.23.206.35"

@interface SocketCenter () <SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *socket;
@end

@implementation SocketCenter

@synthesize socket = _socket;

static SocketCenter *sharedCenter = nil;

-(void)dealloc
{
    if (!_socket) {
        [_socket close];
    }
}

#pragma mark - Class Factory Methods

+ (id)centerWithRoomID:(NSString *)roomID;
{
    SocketCenter *center = [self sharedCenter];
    NSURL *roomURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kBaseURL,roomID]];
    center.socket = [[SRWebSocket alloc] initWithURL:roomURL];
    return center;
}

+ (id)sharedCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCenter = [[self alloc] init];
    });
    return sharedCenter;
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Socket Receive: %@!", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Socket Opened!");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Socket Failed!");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"Socket Closed!");
}



@end
