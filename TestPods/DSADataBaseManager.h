//
//  DSADataBaseManager.h
//  TestSqlite
//
//  Created by 王兴朝 on 13-3-7.
//  Copyright (c) 2013年 bitcar. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@class FMResultSet;

#if ! __has_feature(objc_arc)  //不使用ARC技術
    #define DSARelease(__v) ([__v release]);
    #define DSARetain(__v) ([__v retain]);
    #define DSAAutorelease(__v) ([__v autorelease]);
#else
//使用ARC技術
    #define DSARelease(__v)
    #define DSARetain(__v)
    #define DSAAutorelease(__v)
#endif

@interface DSADataBaseManager : NSObject
{
    dispatch_queue_t _queue;
    FMDatabase *_db;
    NSDictionary *exceptionUserInfoDic;
}
@property(nonatomic,strong)NSDictionary *exceptionInfoDic;
@property(nonatomic,strong)FMDatabase *myDataBase;
+ (DSADataBaseManager *)sharedInstance;
-(void)resetDB;
//查询操作
+ (FMResultSet *)executeQuery:(NSString *)selectSQL;//在1.1版本以后此方法将被executeSelect:取代
+ (FMResultSet *)executeSelect:(NSString *)selectSQL;
+ (NSMutableArray *) arrayExecuteQuery:(NSString *)selectSQL;
+ (NSMutableArray *) dsaArrayExecuteQuery:(NSString *)selectSQL;
+ (int)intForExecute:(NSString *)SQL;
//执行插入、更新、删除的操作
- (BOOL)executeUpdate:(NSString *)SQL;//在1.1版本以后此方法将被changeNumbersExecuteUpdate:取代
+ (BOOL)executeUpdateTransaction:(NSString *)SQL;
//事务方式----执行插入、更新、删除的操作
- (BOOL)executeUpdateInTransaction:(NSArray *)sqlArray;//在1.1版本以后此方法将被executeUpdateTransaction:取代
+ (BOOL)executeUpdateTransactions:(NSArray *)sqlArray;
- (NSDictionary *)executeUpdateInTransactionWithException:(NSArray *)sqlArray;
//执行插入、更新、删除的操作 返回影响的记录条数
- (int)changesExecuteUpdate:(NSString *)SQL;//在1.1版本以后此方法将被changeNumbersExecuteUpdate:取代
+ (int)changeNumbersExecuteUpdate:(NSString *)SQL;

//事务方式----执行插入、更新、删除的操作 返回影响的记录条数
- (int)changesExecuteUpdateInTransaction:(NSArray *)sqlArray;//在1.1版本以后此方法将被changeNumbersExecuteUpdateInTransaction:取代
+ (int)changeNumbersExecuteUpdateInTransaction:(NSArray *)sqlArray;

+(void)instanceDistory;
//获取结果集数组
+(NSMutableArray *)FMResultSet2NSArray:(FMResultSet *)_FMResultSet;

@end
