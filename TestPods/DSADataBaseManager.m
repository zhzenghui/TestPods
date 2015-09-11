//
//  DSADataBaseManager.m
//  TestSqlite
//
//  Created by 王兴朝 on 13-3-7.
//  Copyright (c) 2013年 bitcar. All rights reserved.
//

#import "DSADataBaseManager.h"
#import <FMDB/FMDB.h>

static DSADataBaseManager *shareManager = nil;
static FMDatabaseQueue *writeQueue = nil;
@interface DSADataBaseManager()
{
    FMDatabase *readDatabase;
}
@property (nonatomic,retain) FMDatabase *readDatabase;
@end

@implementation DSADataBaseManager
@synthesize readDatabase;
@synthesize myDataBase;
@synthesize exceptionInfoDic;
#pragma mark -
#pragma mark 创建数据库连接

#define DATABASEPATH @""
+ (DSADataBaseManager *)sharedInstance
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shareManager = [[[self class] alloc] init];
        });
        return shareManager;
}

- (id)init
{
    NSLog(@"DATABASEPATH = %@",DATABASEPATH);
    self = [super init];
    if (self) {
        FMDatabase *rfd = [[FMDatabase alloc] initWithPath:DATABASEPATH];
        if (![rfd open]) {
            NSLog(@"不能打开数据库连接: %@",DATABASEPATH);
            abort();
        }
        self.readDatabase = rfd;
        self.myDataBase=rfd;
        DSARelease(rfd);
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"fmdb.%@", self] UTF8String], NULL);
    }
    return self;
}
-(void)resetDB
{
    return;

//    self.readDatabase=nil;
//    FMDatabase *rfd = [[FMDatabase alloc] initWithPath:DATABASEPATH];
//    if (![rfd open]) {
//        NSLog(@"不能打开数据库连接: %@",DATABASEPATH);
//        abort();
//    }
//    self.readDatabase = rfd;
//    //    self.myDataBase=rfd;
//    DSARelease(rfd);
}

#pragma mark -
#pragma mark 查询操作
+ (FMResultSet *)executeQuery:(NSString *)selectSQL
{
    FMResultSet *rs = nil;
    @synchronized([DSADataBaseManager sharedInstance]){
        FMDatabase *readDatabase = [DSADataBaseManager sharedInstance].readDatabase;
        rs = [readDatabase executeQuery:selectSQL];
        if ([readDatabase hadError]) {
            NSLog(@"查询错误： %d", [readDatabase lastErrorCode]);
            NSLog(@"查询错误： %@", [readDatabase lastErrorMessage]);
        }
    }
    return rs;
}
+ (FMResultSet *)dsaExecuteQuery:(NSString *)selectSQL
{
    FMResultSet *rs = nil;
    @synchronized([DSADataBaseManager sharedInstance]){
        FMDatabase *readDatabase = [DSADataBaseManager sharedInstance].myDataBase;
        rs = [readDatabase executeQuery:selectSQL];
        if ([readDatabase hadError]) {
            NSLog(@"查询错误： %d", [readDatabase lastErrorCode]);
            NSLog(@"查询错误： %@", [readDatabase lastErrorMessage]);
        }
    }
    
    return rs;
}
+(void)instanceDistory
{
    shareManager=nil;
}
+ (NSMutableArray *) arrayExecuteQuery:(NSString *)selectSQL
{
    NSLog(@"DSADataBaseManager  selectSQL  = %@",selectSQL);
    FMDatabase *readDatabase = [DSADataBaseManager sharedInstance].readDatabase;
    FMResultSet *vFmResultSet = nil;
    NSMutableArray *vResult=nil;
    @synchronized([DSADataBaseManager sharedInstance]){
        vFmResultSet = [readDatabase executeQuery:selectSQL];
        if ([readDatabase hadError]) {
            NSLog(@"查询错误： %d", [readDatabase lastErrorCode]);
            NSLog(@"查询错误： %@", [readDatabase lastErrorMessage]);
        }
        vResult= [[NSMutableArray alloc] init];
        while ([vFmResultSet next])
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (int i=0; i<vFmResultSet.columnCount; i++) {
                NSString *columnName = [vFmResultSet columnNameForIndex:i];
                id value1=[vFmResultSet stringForColumnIndex:i];
                if(value1==nil||(NSNull *)value1==[NSNull null])
                {
                    value1=@"";
                }
                [dic setValue:[NSString stringWithFormat:@"%@",value1] forKey:columnName];
            }
            [vResult addObject:dic];
        }
        [vFmResultSet close];
        
    }
    return vResult;
}
+ (NSMutableArray *) dsaArrayExecuteQuery:(NSString *)selectSQL
{
    NSLog(@"%@",selectSQL);
    FMDatabase *readDatabase = [DSADataBaseManager sharedInstance].myDataBase;
    FMResultSet *vFmResultSet = nil;
    NSMutableArray *vResult=nil;
    @synchronized([DSADataBaseManager sharedInstance]){
        vFmResultSet = [readDatabase executeQuery:selectSQL];
        if ([readDatabase hadError]) {
            NSLog(@"查询错误： %d", [readDatabase lastErrorCode]);
            NSLog(@"查询错误： %@", [readDatabase lastErrorMessage]);
        }
        vResult= [[NSMutableArray alloc] init];
        while ([vFmResultSet next]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (int i=0; i<vFmResultSet.columnCount; i++) {
                NSString *columnName = [vFmResultSet columnNameForIndex:i];
                id value1=[vFmResultSet stringForColumnIndex:i];
                if(value1==nil||(NSNull *)value1==[NSNull null])
                {
                    value1=@"";
                }
                [dic setValue:[NSString stringWithFormat:@"%@",value1] forKey:columnName];
            }
            [vResult addObject:dic];
        }
        [vFmResultSet close];
    }
    return vResult;
}

+ (FMResultSet *)executeSelect:(NSString *)selectSQL
{
    return [DSADataBaseManager executeQuery:selectSQL];
}
//返回查询的个数
+ (int)intForExecute:(NSString *)SQL
{
    @synchronized([DSADataBaseManager sharedInstance]){
        return [[DSADataBaseManager sharedInstance].readDatabase intForQuery:SQL];
    }
}
+ (int)dsaIntForExecute:(NSString *)SQL
{
    @synchronized([DSADataBaseManager sharedInstance]){
        return [[DSADataBaseManager sharedInstance].myDataBase intForQuery:SQL];
    }
}
#pragma mark -
#pragma mark 执行插入、更新、删除的操作
- (BOOL)executeUpdate:(NSString *)SQL
{
    
    __block BOOL flag = YES;
    @synchronized([DSADataBaseManager sharedInstance]){
        
        writeQueue = [FMDatabaseQueue databaseQueueWithPath:DATABASEPATH];
        [writeQueue inDatabase:^(FMDatabase *db) {
            [db open];
            if (![db open]) {
                NSLog(@"不能打开数据库连接: %@",DATABASEPATH);
                abort();
            }
            
            flag = [db executeUpdate:SQL];
            if (flag == NO) {
                NSLog(@"执行数据库操作时出错,sql语句: %@", SQL);
            }
            [db close];
        }];
        [writeQueue close];
    }
    return flag;
}
+ (BOOL)executeUpdateTransaction:(NSString *)SQL
{
    return [[DSADataBaseManager sharedInstance] executeUpdate:SQL];
}
#pragma mark -
#pragma mark 事务---执行插入、更新、删除的操作

- (FMDatabase*)database {
    if (!_db) {
        _db = FMDBReturnRetained([FMDatabase databaseWithPath:DATABASEPATH]);
        
        if (![_db open]) {
            FMDBRelease(_db);
            _db  = 0x00;
            return 0x00;
        }
    }
    return _db;
}
-(void)throwException:(NSException *)exception
{
    self.exceptionInfoDic=[NSDictionary dictionaryWithDictionary:exception.userInfo];
}
- (NSDictionary *)executeUpdateInTransactionWithException:(NSArray *)sqlArray
{
    
    
    self.exceptionInfoDic=nil;
    @synchronized([DSADataBaseManager sharedInstance]){
        writeQueue = [FMDatabaseQueue databaseQueueWithPath:DATABASEPATH];
        [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            [db open];
            if (![db open]) {
                NSLog(@"不能打开数据库连接: %@",DATABASEPATH);
                abort();
            }
            [sqlArray enumerateObjectsUsingBlock:^(NSString *SQL, NSUInteger idx, BOOL *stop) {
                @try {
                    [db executeUpdate:SQL];
                }
                @catch (NSException *exception) {
                    [[DSADataBaseManager sharedInstance]throwException:exception];
                    *stop = YES;
                    *rollback = YES;
                    
                    NSLog(@"事务模式--执行数据库操作时出错,sql语句: %@", SQL);
                    return ;
                }

            }];
        }];
        
        [writeQueue close];
        return self.exceptionInfoDic;
    }
    
 
}
- (void)execute:(FMDatabase*)database UpdateWithException:(NSString*)sql, ...
{
    va_list args;
    va_start(args, sql);
    NSError *error;
    BOOL result = [database executeUpdate:sql withErrorAndBindings:&error];
    if(result==NO&&error!=nil)
    {
        
        NSLog(@"%@执行错误，错误原因为：%@",sql,error.localizedDescription);
        NSString *errorSql=error.localizedDescription;
        NSMutableDictionary *mutDic=[NSMutableDictionary dictionaryWithCapacity:0];
        if([errorSql rangeOfString:@"values for"].location !=NSNotFound)//sql语句中列个数与值个数不对应
        {
            [mutDic setObject:@"1" forKey:@"errorCode"];
        }
        if([errorSql rangeOfString:@"has no column"].location!=NSNotFound)//sql中缺少列
        {
            [mutDic setObject:@"2" forKey:@"errorCode"];
        }
        [mutDic setObject:sql forKey:@"errorSql"];
        [mutDic setObject:error.localizedDescription forKey:@"errorDescription"];
//        [mutDic setObject:[ToolKit getSerialNumber] forKey:@"IpadSN"];
        [mutDic setObject:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"errorDate"];
        
        NSException *e = [NSException exceptionWithName: @"sql执行异常"
                                                 reason: error.localizedDescription
                                               userInfo: mutDic];
        va_end(args);
        
        @throw e;
        
    }else
    {
        va_end(args);
    }
}

- (BOOL)executeUpdateInTransaction:(NSArray *)sqlArray
{
    @synchronized([DSADataBaseManager sharedInstance]){
        __block BOOL flag = YES;
        writeQueue = [FMDatabaseQueue databaseQueueWithPath:DATABASEPATH];
        [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db open];
            if (![db open]) {
                NSLog(@"不能打开数据库连接: %@",DATABASEPATH);
                abort();
            }
            [sqlArray enumerateObjectsUsingBlock:^(NSString *SQL, NSUInteger idx, BOOL *stop) {
                flag = [db executeUpdate:SQL];
                if (flag == NO) {
                    NSLog(@"事务模式--执行数据库操作时出错,sql语句: %@", SQL);
                    *stop = YES;
                    *rollback = YES;
                    [db close];
                    return ;
                }
            }];
        }];
        [writeQueue close];
        return flag;
    }
}
+ (BOOL)executeUpdateTransactions:(NSArray *)sqlArray
{
    return [[DSADataBaseManager sharedInstance] executeUpdateInTransaction:sqlArray];
    
}
//执行插入、更新、删除的操作 返回影响的记录条数
- (int)changesExecuteUpdate:(NSString *)SQL
{
    
    @synchronized([DSADataBaseManager sharedInstance]){
        __block int change = 0;
        writeQueue = [FMDatabaseQueue databaseQueueWithPath:DATABASEPATH];
        [writeQueue inDatabase:^(FMDatabase *db) {
            [db open];
            if (![db open]) {
                NSLog(@"不能打开数据库连接: %@",DATABASEPATH);
                abort();
            }
            
            BOOL flag = [db executeUpdate:SQL];
            if (flag == NO) {
                NSLog(@"执行数据库操作时出错,sql语句: %@", SQL);
            }
            change = [db changes];
            
            [db close];
        }];
        [writeQueue close];
        return change;
    }
    
}
+ (int)changeNumbersExecuteUpdate:(NSString *)SQL
{
    return [[DSADataBaseManager sharedInstance] changesExecuteUpdate:SQL];
}
+(NSMutableArray *)FMResultSet2NSArray:(FMResultSet *)_FMResultSet
{
    @synchronized([DSADataBaseManager sharedInstance]){
        NSMutableArray *ret = [[NSMutableArray alloc] init];
        while ([_FMResultSet next]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (int i=0; i<_FMResultSet.columnCount; i++) {
                NSString *columnName = [_FMResultSet columnNameForIndex:i];
                NSString *value = [_FMResultSet stringForColumn:columnName];
                [dic setValue:value forKey:columnName];
            }
            [ret addObject:dic];
        }
        return ret;
    }
}
//事务方式----执行插入、更新、删除的操作 返回影响的记录条数
- (int)changesExecuteUpdateInTransaction:(NSArray *)sqlArray
{
    
    @synchronized([DSADataBaseManager sharedInstance]){
        __block int change = 0;
        writeQueue = [FMDatabaseQueue databaseQueueWithPath:DATABASEPATH];
        [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db open];
            if (![db open]) {
                NSLog(@"不能打开数据库连接: %@",DATABASEPATH);
                abort();
            }
            
            [sqlArray enumerateObjectsUsingBlock:^(NSString *SQL, NSUInteger idx, BOOL *stop) {
                BOOL flag = [db executeUpdate:SQL];
                change += [db changes];
                if (flag == NO) {
                    NSLog(@"事务模式--执行数据库操作时出错,sql语句: %@", SQL);
                    *stop = YES;
                    *rollback = YES;
                    [db close];
                    return ;
                }
            }];
        }];
        [writeQueue close];
        return change;
    };
    
}

+ (int)changeNumbersExecuteUpdateInTransaction:(NSArray *)sqlArray
{
    return [[DSADataBaseManager sharedInstance] changesExecuteUpdateInTransaction:sqlArray];
}


@end