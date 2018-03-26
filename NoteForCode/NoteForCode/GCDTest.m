//
//  GCDTest.m
//  NoteForCode
//
//  Created by Instanza on 2018/3/21.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import "GCDTest.h"

@implementation GCDTest
- (void)run {
    dispatch_queue_t queue = dispatch_queue_create("com.SerialQue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"test");
    });
}
@end
