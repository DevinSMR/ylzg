//
//  DBManager.h
//  Mango
//
//  Created by lanou3g on 16/5/14.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessBlock)(BOOL result);
@interface DBManager : NSObject
+ (instancetype)shareManager;
- (void)openDB;
- (void)createTable;
//存储搜索历史
- (void)saveSearchHistory:(NSString *)history Success:(SuccessBlock)result;
//获取搜索历史
- (NSArray *)selectAllSearchHistory;
//删除搜索历史
- (void)deleteSearchHistory;
@end
