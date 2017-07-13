/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>

/**
 * tool - 验证表情
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NSString (Emoji)
+(BOOL)isContainsEmoji:(NSString *)string;
@end
