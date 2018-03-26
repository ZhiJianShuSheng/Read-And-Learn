//
//  NotificationTest.m
//  NoteForCode
//
//  Created by Instanza on 2018/3/20.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import "NotificationTest.h"
NSString *kNotif_Sub = @"kNotif_Sub";
NSString *kNotif_Main = @"kNotif_Main";

@interface NotificationTest()
@property (nonatomic, strong) NSThread *subAddNotifThread;
@property (nonatomic, strong) NSThread *subPostNotifThread;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation NotificationTest
- (void)addNotiInSubThread {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(log) name:kNotif_Main object:self];
        while (1) {
            [NSThread sleepForTimeInterval:10];
            NSLog(@"unsleep");
        }
    });
    
//
//    self.subAddNotifThread = [[NSThread alloc] initWithTarget:self selector:@selector(subThreadAddNotif) object:nil];
//    self.subAddNotifThread.name = @"kNotif_subAddNotifThread_Test";
//    [self.subAddNotifThread start];
}

- (void)addNotiInMainThread {
//    dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logForNil:) name:nil object:nil];
//    });
}

- (void)pushNotiInSubThread {
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(0, 0) , ^{
//        NSLog(@"Sub Thread Post");
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_Main object:nil];
//
//        while (1) {
//
//        }
//    });
    
    self.subPostNotifThread = [[NSThread alloc] initWithTarget:self selector:@selector(subThreadPostNotif) object:nil];
    self.subPostNotifThread.name = @"kNotif_subPostNotifThread_Test";
    [self.subPostNotifThread start];
}

- (void)pushNotiInMainThread {
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Main Thread Post");
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_Main object:nil];
//    });
}

- (void)logForNil:(NSNotification *)notif {
    
    NSLog(@"Notif Name:%@", notif.name);
//    if ([NSThread currentThread] == [NSThread mainThread]) {
//         NSLog(@"Sub Thread %@: Receive Notif", [NSThread currentThread].name);
//    } else {
//        if ([NSThread currentThread].name) {
//            NSLog(@"Sub Thread %@: Receive Notif", [NSThread currentThread].name);
//        } else {
//            NSLog(@"Sub Thread Receive Notif");
//        }
//    }
}
- (void)log {
    if ([NSThread currentThread] == [NSThread mainThread]) {
        NSLog(@"Main Thread Receive Notif");
    } else {
        if ([NSThread currentThread].name) {
            NSLog(@"Sub Thread %@: Receive Notif", [NSThread currentThread].name);
        } else {
            NSLog(@"Sub Thread Receive Notif");
        }
    }
}

- (void)run {
    _operationQueue = [[NSOperationQueue alloc]init];
//    [[NSNotificationCenter defaultCenter] addObserverForName:kNotif_Main object:nil queue:_operationQueue usingBlock:^(NSNotification * _Nonnull note) {
//        NSLog(@"usingBlock");
//    }];
//    [self addNotiInSubThread];
    [self addNotiInMainThread];
    
//    [self pushNotiInSubThread];
    [self pushNotiInMainThread];
    
//    NSNotification *notif = [[NSNotification alloc]init];
    
//    NSNotification *notif = [[NSNotification alloc]initWithName:@"name" object:self userInfo:nil];
    

}



- (void)subThreadAddNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(log) name:kNotif_Main object:nil];
    
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)subThreadPostNotif {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_Main object:nil];
    
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}
@end
