//
//  ContentPusher.m
//  FBHack
//
//  Created by Brandon Millman on 10/6/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import "ContentPusher.h"

#define kBaseURL @"http://23.23.206.35/"
#define kPushPath @"api/album"
#define kEventPhoto @"PUSH_PHOTO"


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


- (void)pushPhoto:(NSString *)contentURLString withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    NSDictionary *payload = @{  @"link" : contentURLString,
                                @"width" : [NSString stringWithFormat: @"%.2f", width],
                                @"height" : [NSString stringWithFormat: @"%.2f", height]};
    NSLog(@"%@", payload);
    NSDictionary *params = @{@"type" : kEventPhoto, @"payload" : payload};

    [self postPath:[NSString stringWithFormat:@"%@/%@", kPushPath, self.roomID] parameters:params
        success:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"ContentPushed");
        }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    } ];
}

@end
