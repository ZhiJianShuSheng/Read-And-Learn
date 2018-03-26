//
//  ViewController.m
//  NoteForCode
//
//  Created by Instanza on 2018/3/13.
//  Copyright © 2018年 wesly. All rights reserved.
//

#import "ViewController.h"
#import "BlockTest.h"
#import "RunLoopTest.h"
#import "NotificationTest.h"
#import "GCDTest.h"
#import "RuntimeTest.h"
#import "CacheTest.h"
#import "CollectionTest.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tbView;
@property (nonatomic, strong) RunLoopTest *runloopTest;
@property (nonatomic, strong) NotificationTest *notifTest;
@property (nonatomic, strong) GCDTest *gcdTest;
@property (nonatomic, strong) RuntimeTest *runtimeTest;
@property (nonatomic, strong) CacheTest *cacheTest;
@property (nonatomic, strong) CollectionTest *collectionTest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tbView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tbView.delegate = self;
    _tbView.dataSource = self;
//    [self.view addSubview:_tbView];
//    BlockTest *test = [BlockTest new];
    
//    _runloopTest = [RunLoopTest new];
//    [_runloopTest runLoopTest];
    
    _notifTest = [NotificationTest new];
    _gcdTest = [GCDTest new];
    _runtimeTest = [RuntimeTest new];
    _cacheTest = [CacheTest new];
    _collectionTest = [CollectionTest new];
//    [_runtimeTest run];
//    [_notifTest run];
//    [_gcdTest run];
//    [_cacheTest run];
    [_collectionTest run];
}


#pragma mark - UITableViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = NSStringFromSelector(_cmd);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"dd";
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}



- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    
}

- (IBAction)sendSrouceAction:(id)sender {
    [_runloopTest fireSource];
}
- (IBAction)removeSourceAction:(id)sender {
    [_runloopTest removeSource];
}

@end
