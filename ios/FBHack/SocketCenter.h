//
//  SocketCenter.h
//  FBHack
//
//  Created by Brandon Millman on 10/5/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocketCenterDelegate <NSObject>

- (void)eventOccurred:(NSString *)event withPayload:(id)payload;

@end

@interface SocketCenter : NSObject

+ (id)centerWithRoomID:(NSString *)roomID;
+ (id)sharedCenter;

- (void)registerForEvent:(NSString *)event withDelegate:(id<SocketCenterDelegate>)delegate;

@end


