/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * tool - 弹出提示框
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGMBProgressHUD : NSObject
+ (void)alertView:(NSString *)string view:(UIView *)view;
@end
