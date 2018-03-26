//
//  BlockTest.m
//  NoteForCode
//
//  Created by Instanza on 2018/3/14.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import "BlockTest.h"


typedef void(^BlockProperty)(void);
typedef int (^blk_t)(int);

@interface BlockTest()

@property (nonatomic, strong) NSObject *blockRefObj;
@property (nonatomic, copy) BlockProperty blockProperty;


@end


blk_t BlockAutoCopyFunc(int rate)
{
    blk_t bl = ^(int count){
        return rate * count;
        
    };
    return bl;
}

BlockProperty globalBlock = ^(){
    printf("123");
};


//没有捕获变量
void blockFunc0()
{
    void (^block)(void) = ^{
    
    };
    block();
}

//普通局部变量
void blockFunc1()
{
    int num = 100;
    void (^block)(void) = ^{
        NSLog(@"num equal %d", num);
    };
    num = 200;
    block();
}
//普通__block局部变量
void blockFunc2()
{
    __block int num = 100;
    void (^block)(void) = ^{
        NSLog(@"num equal %d", num);
    };
    num = 200;
    block();
}

//全局变量
int num = 100;
void blockFunc3()
{
    void (^block)(void) = ^{
        NSLog(@"num equal %d", num);
    };
    num = 200;
    block();
}

//静态变量
void blockFunc4()
{
    static int num = 100;
    void (^block)(void) = ^{
        NSLog(@"num equal %d", num);
        
    };
    num = 200;
    block();
}


/************ ARC下编译器手动拷贝block ************/
id getBlockArray()
{
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            ^{NSLog(@"blk0:%d", val);},
            ^{NSLog(@"blk1:%d", val);}, nil];
}



@implementation BlockTest
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.blockRefObj = [NSObject new];
        
        self.blockProperty = ^{
            NSLog(@"%@",self.blockRefObj);
        };
        
        __block NSObject *tmpObj = [NSObject new];
        
        __weak NSObject *weakTmpObj = tmpObj;
        void(^tmpBlock)(void) = ^() {
            NSLog(@"%@", tmpObj);
            NSLog(@"%@", weakTmpObj);
        };
    
//        NSArray *array = getBlockArray();
//        void (^b)(void) = array[0];
//        b();
    }
    return self;
}
- (void)run {
    
}
@end
