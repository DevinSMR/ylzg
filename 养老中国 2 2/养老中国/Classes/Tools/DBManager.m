//
//  DBManager.m
//  Mango
//
//  Created by lanou3g on 16/5/14.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "DBManager.h"
#import <FMDatabase.h>
@implementation DBManager
+ (instancetype)shareManager {
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc]init];
    });
    return manager;
}

//数据库指针
static FMDatabase *database = nil;

//打开数据库
- (void)openDB {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"ylzg.sqlite"];
    NSLog(@"%@",dbPath);
    //打开创建数据库
    database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        NSLog(@"数据库打开成功");
    }
}

/**
 *  创建表
 */
- (void)createTable {
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS table_history (searchid INTEGER PRIMARY KEY AUTOINCREMENT,searchHistory TEXT)";
    BOOL result = [database executeUpdate:sql];
    if (result) {
        NSLog(@"创建表成功");
    }
}

/**
 *  插入数据
 */
- (void)saveSearchHistory:(NSString *)history Success:(SuccessBlock)result{
    [self openDB];
    [self createTable];
    BOOL result2 = [database executeUpdateWithFormat:@"INSERT INTO table_history (searchHistory) VALUES (%@)",history];
    if (result2) {
        result(result2);
    }
}


/**
 *  移除数据
 */
- (void)deleteSearchHistory{
    [self openDB];
    [self createTable];
    BOOL result = [database executeUpdate:@"DELETE FROM table_history"];
    if (result) {
        NSLog(@"删除成功");
    }
}


/**
 *  查询搜索历史
 */
- (NSArray *)selectAllSearchHistory {
    [self openDB];
    [self createTable];
    FMResultSet *resultSet = [database executeQueryWithFormat:@"SELECT * FROM table_history"];
    //声明一个数组
    NSMutableArray *array = [NSMutableArray new];
    while ([resultSet next]) {
        NSString *history = [resultSet stringForColumn:@"searchHistory"];
        [array addObject:history];
    }
    return array;
}


@end
