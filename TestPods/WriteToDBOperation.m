//
//  WriteToDBOperation.m
//  TestPods
//
//  Created by xy on 15/9/14.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "WriteToDBOperation.h"
#import "WriteToDB.h"
#import "T.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "NSString+Eccape.h"
#import "DAPXMLParser.h"


@implementation WriteToDBOperation


static FMDatabaseQueue *_writeQueue = nil;


- (id)initWithRecord:(NSArray *)record  delegate:(id<WriteToDBDelegate>)theDelegate {
    
    if (self = [super init]) {
        _delegate = theDelegate;
        _array = record;
        _writeQueue= [FMDatabaseQueue databaseQueueWithPath:GetDATABASE];

    }
    return self;
}






- (void)write:(NSArray *)sqlArray {
    
        
    [_writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        __block BOOL flag = YES;

        [sqlArray enumerateObjectsUsingBlock:^(NSString *SQL, NSUInteger idx, BOOL *stop) {
            

            flag = [db executeUpdate:SQL];
            if (flag == NO) {
                NSLog(@"事务模式--执行数据库操作时出错,sql语句: %@", SQL);
                *stop = YES;
                *rollback = YES;
            }
        }];

    }];

    [_writeQueue close];
    _writeQueue = nil;
}








#pragma mark -
#pragma mark - Downloading image



- (void)main {
    
    @autoreleasepool {
        if (self.isCancelled)
            return;

        uint64_t begin1 = mach_absolute_time();
        //  write db
        
        NSArray *a = _array;
        [self write:a];
        _array = nil;

        uint64_t end1 = mach_absolute_time();

        NSLog(@"db insert sql count: %i个  Time:  %g s   ", _array.count,  MachTimeToSecs(end1 - begin1));
        
        
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(writeToDbDidFinish:) withObject:nil waitUntilDone:NO];

        
        if (self.isCancelled)
            return;
        
        
    }
}



@end
