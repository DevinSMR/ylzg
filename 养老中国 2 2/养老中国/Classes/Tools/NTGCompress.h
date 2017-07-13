/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>

/**
 * tool - 对图片URL拼接压缩的比例
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGCompress : NSObject
+ (NSString *)compressUrl:(NSString *)url width:(float)width heigth:(float)heigth;
@end
