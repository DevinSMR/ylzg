/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGDetection.h"

/**
 * tool - 检测网络
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGDetection
+ (NetworkStatus)netStatus {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    return status;
}

+ (NSString *)stringFromStatus:(NetworkStatus)status {
    NSString *string;
    switch (status) {
        case NotReachable:
            string = @"网络未连接";
            break;
        case ReachableViaWiFi:
            string = @"已连接WIFI";
            break;
        case ReachableViaWWAN:
            string = @"已连接蜂窝网络";
            break;
            
        default:
            break;
    }
    return string;
}

//+ (NSString *)detectionString {
//    return [self stringFromStatus:[NTGDetection netStatus]];
//}

+ (MBProgressHUD *)alertProcessViewWithStatus:(NetworkStatus)status detectionString:(NSString *)string mode:(MBProgressHUDMode)mode{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/success"]];
    hud.mode = mode;
    hud.labelText = string;
    [hud show:YES];
    [hud hide:YES afterDelay:0.5];
    return hud;
}
@end
