//
//  ContentPusher.m
//  FBHack
//
//  Created by Brandon Millman on 10/6/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import "ContentPusher.h"

#define kBaseURL @"http://23.23.206.35/"
#define kPushPath @"album"
#define kPushType @"PUSH_CONTENT"

@interface ContentPusher ()
@property (nonatomic, copy) NSString *roomID;
@end

@implementation ContentPusher

+ (ContentPusher *)pusherWithRoomID:(NSString *)roomID
{
    ContentPusher *pusher = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    pusher.roomID = roomID;
    return pusher;
}

- (void)pushContent:(NSString *)contentURLString
{
    NSDictionary *payload = @{@"link" : contentURLString};
    NSDictionary *params = @{@"type" : kPushType, @"payload" : payload};

    [self postPath:kPushPath parameters:params
        success:nil
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    } ];
}

@end
