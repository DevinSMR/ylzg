/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>

/**
 *  Entity - 所有分页的根容器
 * @author 谷强
 * @vertion 2015 Apr 16, 2015 11:04:30 AM
 * 
 */
@interface NTGPage : NSObject

/** 要进行分页的对象 : 使用时动态装入类型 */
@property(nonatomic,strong) NSArray *content;

@end
