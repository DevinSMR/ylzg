/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <MBProgressHUD.h>

/**
 * tool - 检测网络
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGDetection : NSObject

+ (NetworkStatus)netStatus;

+ (NSString *)stringFromStatus:(NetworkStatus)status;

//+ (NSString *)detectionString;

+ (MBProgressHUD *)alertProcessViewWithStatus:(NetworkStatus)status detectionString:(NSString *)string mode:(MBProgressHUDMode)mode;
@end
