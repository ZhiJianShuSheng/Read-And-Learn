//
//  RunLoopTest.m
//  NoteForCode
//
//  Created by Instanza on 2018/3/16.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import "RunLoopTest.h"
static NSTimeInterval lastTime = 0;
static NSString *CustomRunLoopMode = @"CustomRunLoopMode";
static CFRunLoopSourceRef cfsref;
static CFRunLoopRef cfrl;
@interface RunLoopTest()
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation RunLoopTest
#pragma mark - Test Entry
- (void)runLoopTest {
//    [self test_Source];
//    [self test_addRunloopObserver];
    [self test_Timer];
}

#pragma mark - Runloop Model
- (void)test_runLoopModel {

//    cfrl = [[NSRunLoop currentRunLoop]getCFRunLoop];
//    CFRunLoopAddCommonMode(cfrl, cfModel);
    // Add custom mode
    CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), (__bridge CFStringRef)(CustomRunLoopMode));
    [[NSRunLoop currentRunLoop] runMode:CustomRunLoopMode
                             beforeDate:[NSDate distantFuture]];
}

#pragma mark - Runloop Observer
- (void)removeSource {
    CFRunLoopRemoveSource(cfrl, cfsref, kCFRunLoopDefaultMode);
    CFRunLoopWakeUp(cfrl);
}

- (void)addSource {
   [self subThread];
}

- (void)fireSource {
    // wake up sub-thread and fire input source
    CFRunLoopSourceSignal(cfsref);
    CFRunLoopWakeUp(cfrl);
}

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
  
    NSLog(@"RunLoopSourceScheduleRoutine");
}

void RunLoopSourcePerformRoutine (void *info)
{
    NSLog(@"RunLoopSourcePerformRoutine");
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
   
    NSLog(@"RunLoopSourceCancelRoutine");
}

- (void)subThread {
    /*
     typedef struct {
     CFIndex    version;
     void *    info;
     const void *(*retain)(const void *info);
     void    (*release)(const void *info);
     CFStringRef    (*copyDescription)(const void *info);
     Boolean    (*equal)(const void *info1, const void *info2);
     CFHashCode    (*hash)(const void *info);
     void    (*schedule)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
     void    (*cancel)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
     void    (*perform)(void *info);
     } CFRunLoopSourceContext;
     */
//    CFRunLoopSourceContext context = {
//        0,
//        NULL,
//        CFRetain,
//        CFRelease,
//        (CFStringRef(*)(const void *))CFCopyDescription,
//        NULL,
//        NULL,
//        RunLoopSourceScheduleRoutine,
//        RunLoopSourceCancelRoutine,
//        RunLoopSourcePerformRoutine
//    };

    CFRunLoopSourceContext context = {
        0,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        RunLoopSourceScheduleRoutine,
        RunLoopSourceCancelRoutine,
        RunLoopSourcePerformRoutine
    };
    
    cfsref = CFRunLoopSourceCreate(NULL, 0, &context);
    cfrl = [[NSRunLoop currentRunLoop]getCFRunLoop];
    CFRunLoopAddSource(cfrl, cfsref, kCFRunLoopDefaultMode);
    
    //释放
    CFRelease(cfsref);
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef src = cfsref;
    CFRunLoopAddSource(runloop, src, kCFRunLoopDefaultMode);
    
    // start the runloop, thread will be blocked here
    CFRunLoopRun();
    
    NSLog(@"runloop is stoped, sub-thread will finish execute");
    
}
- (void)test_Source {
    // start a new thread to listen event
    [NSThread detachNewThreadSelector:@selector(subThread) toTarget:self withObject:nil];
   
}

//这里处理耗时操作了
static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    /*
     kCFRunLoopEntry = (1UL << 0),
     kCFRunLoopBeforeTimers = (1UL << 1),
     kCFRunLoopBeforeSources = (1UL << 2),
     kCFRunLoopBeforeWaiting = (1UL << 5),
     kCFRunLoopAfterWaiting = (1UL << 6),
     kCFRunLoopExit = (1UL << 7),
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     */
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
            
        default:
            break;
    }
    
}

//添加runloop监听者
- (void)test_addRunloopObserver{
    // 获取 当前的Runloop ref - 指针
    CFRunLoopRef current =  CFRunLoopGetCurrent();
    
    //定义一个RunloopObserver
    CFRunLoopObserverRef defaultModeObserver;
    
    //上下文
    /*
     typedef struct {
     CFIndex    version; //版本号 long
     void *    info;    //这里我们要填写对象（self或者传进来的对象）
     const void *(*retain)(const void *info);        //填写&CFRetain
     void    (*release)(const void *info);           //填写&CGFRelease
     CFStringRef    (*copyDescription)(const void *info); //NULL
     } CFRunLoopObserverContext;
     */
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    /*
     1 NULL空指针 nil空对象 这里填写NULL
     2 模式
     kCFRunLoopEntry = (1UL << 0),
     kCFRunLoopBeforeTimers = (1UL << 1),
     kCFRunLoopBeforeSources = (1UL << 2),
     kCFRunLoopBeforeWaiting = (1UL << 5),
     kCFRunLoopAfterWaiting = (1UL << 6),
     kCFRunLoopExit = (1UL << 7),
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     3 是否重复 - YES
     4 nil 或者 NSIntegerMax - 999
     5 回调
     6 上下文
     */
    //    创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL,
                                                  kCFRunLoopBeforeWaiting|kCFRunLoopEntry|kCFRunLoopBeforeTimers|kCFRunLoopBeforeSources|kCFRunLoopAfterWaiting|kCFRunLoopExit|kCFRunLoopAllActivities,
                                                  YES,
                                                  NSIntegerMax - 999,
                                                  &Callback,
                                                  &context);
    
    //添加当前runloop的观察着
    CFRunLoopAddObserver(current, defaultModeObserver, (__bridge_retained CFStringRef)@"UITrackingRunLoopMode");
    
    //释放
    CFRelease(defaultModeObserver);
}
#pragma mark - Timer Test

- (void)test_Timer {
    
    [self logForRunLoop:[NSRunLoop currentRunLoop]];
    
    //默认值在defaultmodel中
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(testTimer) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:@"UITrackingRunLoopMode"];
//    NSLog(@"%@",[NSRunLoop currentRunLoop]);
//    CFRunLoopRef runLoopRef = [NSRunLoop currentRunLoop].getCFRunLoop;
//    CFRunLoopStop(runLoopRef);
    ////        CFRunLoopRef runLoopRef = [NSRunLoop currentRunLoop].getCFRunLoop;
    //        CFMutableSetRef cfset = runLoopRef->_commonModes;
    //        NSMutableSet *set = (NSMutableSet *)CFBridgingRelease(cfset);
    [self logForRunLoop:[NSRunLoop currentRunLoop]];
    //        NSEnumerator  *enumrator = [set objectEnumerator];
    //        NSString *value;
    //        while (value = [enumrator nextObject]) {
    //            NSLog(@"value %@",value);
    //        }
}
- (void)testTimer {
    NSLog(@"current runloop model:%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"timer duration:%f",CFAbsoluteTimeGetCurrent() - lastTime);
    lastTime = CFAbsoluteTimeGetCurrent();
}


-(void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Log

- (void)logForRunLoop:(NSRunLoop *)runloop {
    CFRunLoopRef runLoopRef = [NSRunLoop currentRunLoop].getCFRunLoop;
    
    //commonModes
    //    CFMutableSetRef cf_CM_Ref = runLoopRef->_commonModes;
    //    [self logForCFMutableSetRef:cf_CM_Ref flag:@"commonModes value"];
    //    //commonModeItems
//    CFMutableSetRef cf_MI_Ref = runLoopRef->_commonModeItems;
//    [self logForCFMutableSetRef:cf_MI_Ref flag:@"commonModeItems value"];
    //
    //    //currentModel
        CFRunLoopModeRef cf_CurretnM_Ref = runLoopRef->_currentMode;
        //source0
        CFMutableSetRef cf_source0 = cf_CurretnM_Ref->_sources0;
        [self logForCFMutableSetRef:cf_source0 flag:@"currentModel source0"];
        CFMutableSetRef cf_source1 = cf_CurretnM_Ref->_sources1;
        [self logForCFMutableSetRef:cf_source1 flag:@"currentModel source1"];
    //
    //
    //    CFMutableArrayRef cf_observer = cf_CurretnM_Ref->_observers;
    //    [self logForCFMutableArrayRef:cf_observer flag:@"currentModel observers"];
    //
    //models
    //    CFMutableSetRef cf_M_Ref = runLoopRef->_modes;
    //    [self logForCFMutableSetRef:cf_M_Ref flag:@"Models value"];
    
}


/**
 1. __bridge只做类型转换，但是不修改对象（内存）管理权
 2. __bridge_retained（也可以使用CFBridgingRetain）将Objective-C的对象转换为Core Foundation的对象，代表OC要将对象所有权交给CF对象自己来管理,所以我们要在ref使用完成以后用CFRelease将其手动释放.
 3. __bridge_transfer（也可以使用CFBridgingRelease）将Core Foundation的对象转换为Objective-C的对象，同时将对象（内存）的管理权交给ARC。
 */
- (void)logForCFMutableSetRef:(CFMutableSetRef)msR flag:(NSString *)flag{
    //    NSMutableSet *set = (__bridge_transfer NSMutableSet *)(msR);
    //    NSMutableSet *set = CFBridgingRelease(msR);
    
    NSMutableSet *set = (__bridge NSMutableSet *)(msR);
    NSEnumerator *cm_Enumrator = [set objectEnumerator];
    id value;
    while (value = [cm_Enumrator nextObject]) {
        NSLog(@"%@: %@",flag, value);
    }
}
- (void)logForCFMutableArrayRef:(CFMutableArrayRef)maR flag:(NSString *)flag{
    NSMutableArray *set = (__bridge NSMutableArray *)(maR);
    NSEnumerator  *cm_Enumrator = [set objectEnumerator];
    id value;
    while (value = [cm_Enumrator nextObject]) {
        NSLog(@"%@: %@",flag, value);
    }
}

- (void)run {
    
}

@end
