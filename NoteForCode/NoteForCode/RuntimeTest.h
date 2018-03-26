//
//  RuntimeTest.h
//  NoteForCode
//
//  Created by Instanza on 2018/3/22.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestProtocol.h"
@interface RuntimeTest : NSObject<TestProtocol>
- (void)run;
@end
