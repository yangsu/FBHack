//
//  SocketCenter.h
//  FBHack
//
//  Created by Brandon Millman on 10/5/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocketCenterDelegate <NSObject>

- (void)eventOccurred:(NSString *)event withPayload:(NSDictionary *)payload;

@end

@interface SocketCenter : NSObject

+ (id)centerWithRoomID:(NSString *)roomID andDelegate:(id<SocketCenterDelegate>)delegate;

- (void)sendEvent:(NSString *)event withPayload:(NSDictionary *)payload;

@property (nonatomic, weak) id<SocketCenterDelegate> delegate;

@end


