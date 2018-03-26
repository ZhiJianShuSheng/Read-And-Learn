//
//  CacheTest.m
//  NoteForCode
//
//  Created by Instanza on 2018/3/25.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import "CacheTest.h"
@interface CacheTest()<NSCacheDelegate>
@property (nonatomic, strong) NSCache *nsCache;

@end

@implementation CacheTest
- (void)run {
    _nsCache = [[NSCache alloc]init];
    _nsCache.name = @"NSCacheTest";
    _nsCache.delegate = self;
//    _nsCache.totalCostLimit = 10;
    _nsCache.countLimit = 5;
    _nsCache.evictsObjectsWithDiscardedContent = YES;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"jpeg"];
    for (int i = 0 ; i < 6; i++) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        [_nsCache setObject:data forKey:[NSString stringWithFormat:@"%d", i]];
        NSLog(@"data size%ld", data.length * (i + 1));
    }
    
//    NSUInteger totalAccesses = [_nsCache objectForKey:@"totalAccesses"];
//    NSHashTable *_objects = [_nsCache objectForKey:@"objects"];
//    for (int i = 0 ; i < 10; i++) {
//        NSObject *obj = [NSObject new];
//        [_nsCache setObject:obj forKey:[NSString stringWithFormat:@"%d", i]];
//    }
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    
}

@end
