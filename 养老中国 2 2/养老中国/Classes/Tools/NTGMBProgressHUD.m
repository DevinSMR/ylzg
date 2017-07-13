/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGMBProgressHUD.h"
#import <MBProgressHUD.h>

/**
 * tool - 弹出提示框
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGMBProgressHUD
+ (void)alertView:(NSString *)string view:(UIView *)view {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = string;
    HUD.margin = 10.f;
   // HUD.yOffset = 150.f;
    HUD.center = view.center;
    [HUD hide:YES afterDelay:1];
}
@end
