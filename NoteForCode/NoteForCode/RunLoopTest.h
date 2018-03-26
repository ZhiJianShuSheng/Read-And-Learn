//
//  RunLoopTest.h
//  NoteForCode
//
//  Created by Instanza on 2018/3/16.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#include <math.h>
#include <stdio.h>
#include <limits.h>
#include <pthread.h>
#include <dispatch/dispatch.h>
#import "TestProtocol.h"

typedef struct _per_run_data {
    uint32_t a;
    uint32_t b;
    uint32_t stopped;
    uint32_t ignoreWakeUps;
} _per_run_data;

typedef mach_port_t __CFPort;
#define CFPORT_NULL MACH_PORT_NULL
typedef mach_port_t __CFPortSet;
typedef struct __CFRunLoopMode *CFRunLoopModeRef;
typedef struct __CFRunLoop *CFRunLoopRef;
typedef struct __CFRuntimeBase {
    uintptr_t _cfisa;
    uint8_t _cfinfo[4];
#if __LP64__
    uint32_t _rc;
#endif
} CFRuntimeBase;

struct __CFRunLoop {
    CFRuntimeBase _base;
    pthread_mutex_t _lock;            /* locked for accessing mode list */
    __CFPort _wakeUpPort;            // used for CFRunLoopWakeUp
    Boolean _unused;
    volatile _per_run_data *_perRunData;              // reset for runs of the run loop
    pthread_t _pthread; //runloop对应的线程
    uint32_t _winthread;
    CFMutableSetRef _commonModes;//存储的是字符串，记录所有标记为common的mode
    CFMutableSetRef _commonModeItems;//存储所有commonMode的item(source、timer、observer)
    CFRunLoopModeRef _currentMode;//当前运行的mode
    CFMutableSetRef _modes;//存储的是CFRunLoopModeRef
    struct _block_item *_blocks_head;
    struct _block_item *_blocks_tail;
    CFAbsoluteTime _runTime;
    CFAbsoluteTime _sleepTime;
    CFTypeRef _counterpart;
};

struct __CFRunLoopMode {
    CFRuntimeBase _base;
    pthread_mutex_t _lock;  /* must have the run loop locked before locking this */
    CFStringRef _name;   //mode名称
    Boolean _stopped;    //mode是否被终止
    char _padding[3];
    //几种事件
    CFMutableSetRef _sources0;  //sources0
    CFMutableSetRef _sources1;  //sources1
    CFMutableArrayRef _observers; //通知
    CFMutableArrayRef _timers;    //定时器
    CFMutableDictionaryRef _portToV1SourceMap; //字典  key是mach_port_t，value是CFRunLoopSourceRef
    __CFPortSet _portSet; //保存所有需要监听的port，比如_wakeUpPort，_timerPort都保存在这个数组中
    CFIndex _observerMask;
#if USE_DISPATCH_SOURCE_FOR_TIMERS
    dispatch_source_t _timerSource;
    dispatch_queue_t _queue;
    Boolean _timerFired; // set to true by the source when a timer has fired
    Boolean _dispatchTimerArmed;
#endif
#if USE_MK_TIMER_TOO
    mach_port_t _timerPort;
    Boolean _mkTimerArmed;
#endif
#if DEPLOYMENT_TARGET_WINDOWS
    DWORD _msgQMask;
    void (*_msgPump)(void);
#endif
    uint64_t _timerSoftDeadline; /* TSR */
    uint64_t _timerHardDeadline; /* TSR */
};


struct __CFRunLoopSource {
    CFRuntimeBase _base;
    uint32_t _bits; //用于标记Signaled状态，source0只有在被标记为Signaled状态，才会被处理
    pthread_mutex_t _lock;
    CFIndex _order;         /* immutable */
    CFMutableBagRef _runLoops;
    union {
        CFRunLoopSourceContext version0;     /* immutable, except invalidation */
        CFRunLoopSourceContext1 version1;    /* immutable, except invalidation */
    } _context;
};

struct __CFRunLoopTimer {
    CFRuntimeBase _base;
    uint16_t _bits;  //标记fire状态
    pthread_mutex_t _lock;
    CFRunLoopRef _runLoop;        //添加该timer的runloop
    CFMutableSetRef _rlModes;     //存放所有包含该timer的 mode的 modeName，意味着一个timer可能会在多个mode中存在
    CFAbsoluteTime _nextFireDate;
    CFTimeInterval _interval;     //理想时间间隔  /* immutable */
    CFTimeInterval _tolerance;    //时间偏差      /* mutable */
    uint64_t _fireTSR;          /* TSR units */
    CFIndex _order;         /* immutable */
    CFRunLoopTimerCallBack _callout;    /* immutable */
    CFRunLoopTimerContext _context; /* immutable, except invalidation */
};

struct __CFRunLoopObserver {
    CFRuntimeBase _base;
    pthread_mutex_t _lock;
    CFRunLoopRef _runLoop;
    CFIndex _rlCount;
    CFOptionFlags _activities;      /* immutable */
    CFIndex _order;         /* immutable */
    CFRunLoopObserverCallBack _callout; /* immutable */
    CFRunLoopObserverContext _context;  /* immutable, except invalidation */
};


@interface RunLoopTest : NSObject<TestProtocol>
- (void)runLoopTest;
-(void)removeTimer;

- (void)fireSource;
- (void)removeSource;
@end
