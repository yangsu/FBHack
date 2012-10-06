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

@synthesize delegate = _delegate;
@synthesize socket = _socket;

-(void)dealloc
{
    if (!_socket) {
        [_socket close];
    }
}

#pragma mark - Class Factory Methods

+ (id)centerWithRoomID:(NSString *)roomID andDelegate:(id<SocketCenterDelegate>)delegate
{
    SocketCenter *center = [[self alloc] init];
    center.delegate = delegate;
    NSURL *roomURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kBaseURL,roomID]];
    center.socket = [[SRWebSocket alloc] initWithURL:roomURL];
    return center;
}


#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Socket Receive: %@!", message);
    // TODO: parse message and alert proper delegates
    
    if(self.delegate)
    {
        
    }
    
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
