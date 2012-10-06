//
//  ContentPusher.h
//  FBHack
//
//  Created by Brandon Millman on 10/6/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ContentPusher : AFHTTPClient

+ (ContentPusher *)pusherWithRoomID:(NSString *)roomID;

- (void)pushPhoto:(NSString *)contentURLString withWidth:(CGFloat)width withHeight:(CGFloat)height;


@end
