//
//  CollectionTest.m
//  NoteForCode
//
//  Created by Instanza on 2018/3/26.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import "CollectionTest.h"
@interface KeyObj : NSObject

@end

@implementation KeyObj


@end


@interface CollectionTest()

@end

@implementation CollectionTest

- (void)run {
    NSSet *set = [NSSet setWithObjects:@"NSSet1",@"NSSet2", nil];//NSarray
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj);
    }];
    
//    KeyObj *keyObj = [KeyObj new];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"NSDictionary",keyObj, nil];
    
    
    NSInteger count = 5000000;
    NSLog(@"%f", CFAbsoluteTimeGetCurrent());
    
    NSMutableSet *mSet = [NSMutableSet new];
    NSTimeInterval mSetDuration = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < count; i++) {
        KeyObj *obj = [KeyObj new];
        [mSet addObject:obj];
    }
    
    [self log:@"NSMutableSet Add Obj" time:CFAbsoluteTimeGetCurrent() - mSetDuration];
    
    
    NSHashTable *hashTable = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    NSTimeInterval hashTableDuration = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < count; i++) {
        KeyObj *obj = [KeyObj new];
        [hashTable addObject:obj];
    }
    [self log:@"NSHashTable Add Obj" time:CFAbsoluteTimeGetCurrent() - hashTableDuration];
    
    
    NSMutableArray *mArray = [NSMutableArray new];
    NSTimeInterval mArrayDuration = CFAbsoluteTimeGetCurrent();
    for (int i = 0; i < count; i++) {
        KeyObj *obj = [KeyObj new];
        [mArray addObject:obj];
    }
    [self log:@"NSMutableArray Add Obj" time:CFAbsoluteTimeGetCurrent() - mArrayDuration];
}

- (void)log:(NSString *)operator time:(NSTimeInterval)time {
    NSLog(@"%@ Cost Time:%f",operator, CFAbsoluteTimeGetCurrent() - time);
}
@end
