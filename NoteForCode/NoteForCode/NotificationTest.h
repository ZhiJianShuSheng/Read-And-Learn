//
//  NotificationTest.h
//  NoteForCode
//
//  Created by Instanza on 2018/3/20.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestProtocol.h"
@interface NotificationTest : NSObject
- (void)addNotiInSubThread;
- (void)addNotiInMainThread;
- (void)pushNotiInSubThread;
- (void)pushNotiInMainThread;
- (void)run;
@end
