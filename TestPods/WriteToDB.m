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



@implementation WriteToDB


+ (instancetype)sharedManager {
    static WriteToDB *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[WriteToDB alloc] init];
    });
    
    return _sharedManager;
}


- (id)init {
    self = [super init];
    
    if (self) {
        sMString = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void)write:(NSString *)sql {
    
    
//        __block int change = 0;÷
    
    
        FMDatabaseQueue *writeQueue = [FMDatabaseQueue databaseQueueWithPath:GetDATABASE];
        [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db open];
            if (![db open]) {
                NSLog(@"不能打开数据库连接: %@",GetDATABASE);
                abort();
            }
            
//            [sqlArray enumerateObjectsUsingBlock:^(NSString *SQL, NSUInteger idx, BOOL *stop) {
//                //DAPWritLog(@"TransactionSQL: %@",SQL);
                BOOL flag = [db executeUpdate:sql];
//                change += [db changes];
                if (flag == NO) {
                    NSLog(@"事务模式--执行数据库操作时出错,sql语句:  ");
//                    *stop = YES;
                    *rollback = YES;
                    [db close];
//                    return ;
                }
//            }];
        }];
        [writeQueue close];
//        change;
}

//INSERT INTO shuffled_tickets (ticket_idx, seed, win_credits, [timestamp], redeemed, prog_levels)
//VALUES  (@ticket_idx, @seed, @win_credits, @timestamp, @redeemed, @prog_levels)
- (NSString *)sqlArray :(NSDictionary *)xmlDict {
    
    NSString *table = xmlDict[@"root"][@"body"][@"Content"][@"DataUnit"][@"DataUnitCode"];
    NSArray *rowList = xmlDict[@"root"][@"body"][@"Content"][@"DataUnit"][@"RowList"][@"Row"];
    

    if ([rowList isKindOfClass:[NSDictionary class]]) {
        
        
        rowList = @[rowList];
    }
    
    
    NSMutableString *sqlMString = [NSMutableString string];
    
    for (NSDictionary *sqlDict in rowList) {
        
    
        [sqlMString appendFormat:@"INSERT INTO %@ ", table];
        [sqlMString appendString:@"("];
        {
            NSMutableString *cs = [NSMutableString string];
            for (NSString *coulmnName in sqlDict.allKeys) {
                [cs appendFormat:@"%@,", coulmnName];
            }
            
            [sqlMString appendString:[cs substringWithRange:NSMakeRange(0, cs.length -1)]];

        }
        
        [sqlMString appendString:@")"];
        [sqlMString appendString:@"VALUES"];
        [sqlMString appendString:@"("];
        
        {
            NSMutableString *cs = [NSMutableString string];
            for (NSString *coulmnName in sqlDict.allValues) {
                [cs appendFormat:@"\"%@\",", coulmnName];
            }
            
            [sqlMString appendString:[cs substringWithRange:NSMakeRange(0, cs.length -1)]];
        }
        [sqlMString appendString:@");"];

    }
    
    
    return sqlMString;
}

- (void)execu {
    
    
    uint64_t begin1 = mach_absolute_time();
    //  write db
    [self write:sMString];
    uint64_t end1 = mach_absolute_time();
    
    NSLog(@"db insert sql   Time  %g s   ", MachTimeToSecs(end1 - begin1));
    
}


static int count = 10;

-(void)writeDB:(NSDictionary *)xmlDict; {
    
    
    
    uint64_t begin = mach_absolute_time();
    // sqls  string
    NSString *str = [self sqlArray:xmlDict];
    uint64_t end = mach_absolute_time();
    
    NSLog(@"xml convert sql   Time  %g s   ", MachTimeToSecs(end - begin));
    [sMString appendString:str];
    
    
    str = nil;
    if (count  == 10) {
        [self execu];
        count = 0;
    }
    else {
        count ++;
    }


    
    

    
    
    
    
    
    
}


@end
