//
//  WriteToDB.m
//  TestPods
//
//  Created by xy on 15/9/11.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "WriteToDB.h"
#import "T.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "NSString+Eccape.h"


@implementation WriteToDB

static FMDatabaseQueue *_writeQueue = nil;

+ (instancetype)sharedManager {
    static WriteToDB *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _writeQueue= [FMDatabaseQueue databaseQueueWithPath:GetDATABASE];

        _sharedManager = [[WriteToDB alloc] init];
    });
    
    return _sharedManager;
}


- (id)init {
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (void)write:(NSArray *)sqlArray {
    

    
    [_writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db open]) {
            NSLog(@"不能打开数据库连接: %@",GetDATABASE);
        }
        __block BOOL flag = YES;

        [sqlArray enumerateObjectsUsingBlock:^(NSString *SQL, NSUInteger idx, BOOL *stop) {
                flag = [db executeUpdate:SQL];
                if (flag == NO) {
                    NSLog(@"事务模式--执行数据库操作时出错,sql语句: %@", SQL);
                    *stop = YES;
                    *rollback = YES;
                }
        }];
        [db close];
        
    }];
    
    
    [_writeQueue close];

    
    
}


- (void)open; {
    

}




//INSERT INTO shuffled_tickets (ticket_idx, seed, win_credits, [timestamp], redeemed, prog_levels)
//VALUES  (@ticket_idx, @seed, @win_credits, @timestamp, @redeemed, @prog_levels)
- (NSArray *)sqlArray :(NSDictionary *)xmlDict {
    
    
    NSMutableArray *sArray = [NSMutableArray array];
    NSString *table = xmlDict[@"root"][@"body"][@"Content"][@"DataUnit"][@"DataUnitCode"];
    NSArray *rowList = xmlDict[@"root"][@"body"][@"Content"][@"DataUnit"][@"RowList"][@"Row"];
    

    if ([rowList isKindOfClass:[NSDictionary class]]) {
        
        
        rowList = @[rowList];
    }
    
    
    
    for (NSDictionary *sqlDict in rowList) {
        NSMutableString *sqlMString = [NSMutableString string];

    
        [sqlMString appendFormat:@"REPLACE INTO %@ ", table];
        [sqlMString appendString:@"("];
        {
            NSMutableString *cs = [NSMutableString string];
            for (NSString *coulmnName in sqlDict.allKeys) {
                [cs appendFormat:@"'%@',", coulmnName];
            }
            
            [sqlMString appendString:[cs substringWithRange:NSMakeRange(0, cs.length -1)]];

        }
        
        [sqlMString appendString:@")"];
        [sqlMString appendString:@"VALUES"];
        [sqlMString appendString:@"("];
        
        {
            NSMutableString *cs = [NSMutableString string];
            for (NSString *coulmnName in sqlDict.allValues) {
                [cs appendFormat:@"'%@',", [coulmnName sqliteEscape]];
            }
            
            [sqlMString appendString:[cs substringWithRange:NSMakeRange(0, cs.length -1)]];
        }
        [sqlMString appendString:@");"];

        [sArray addObject:sqlMString];
    }
    
    
    
    
    return sArray;
}

- (void)execu:(NSArray *)array {
    
    
    uint64_t begin1 = mach_absolute_time();
    //  write db
    [self write:array];
    uint64_t end1 = mach_absolute_time();
    
    NSLog(@"db insert sql count: %i个  Time:  %g s   ", array.count,  MachTimeToSecs(end1 - begin1));
    
}


static int count = 10;

-(void)writeDB:(NSDictionary *)xmlDict; {
    
    
    
    uint64_t begin = mach_absolute_time();
    // sqls  string
    NSArray *array = [self sqlArray:xmlDict];
    uint64_t end = mach_absolute_time();
    
    NSLog(@"xml convert sql   Time  %g s   ", MachTimeToSecs(end - begin));
//    [sMString appendString:str];
//    
//
//    str = nil;
//    if (count  == 10) {
//    [self execu:array];
//        count = 0;
//    }
//    else {
//        count ++;
//    }


    
    

    
    
    
    
    
    
}


@end
