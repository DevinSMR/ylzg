/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>

/**
 * tool - cookies
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGCookies : NSObject

/** 保存从服务器获取的所有cookies */
+ (void) saveCookies;

/** 获取所有保存在用户端的COOKIE,并写入内存 */
+ (void) loadCookies;

@end
