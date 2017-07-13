/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGBusinessResult.h"
#import <UIKit/UIKit.h>
#import "NTGLoginController.h"
#import <MBProgressHUD.h>
#import "NTGDetection.h"
#import "NTGMBProgressHUD.h"

/**
 * tool - 网络业务回调
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGBusinessResult

//- (instancetype)init {
//    return [self initWithNavController:nil];
//}

- (instancetype)initWithNavController:(UINavigationController*) navctlr {
    return [self initWithNavController:navctlr removePreCtrol:NO];
}

/** 当弹出登录框前是否要先POP出上一个控制器 */
- (instancetype)initWithNavController:(UINavigationController*) navctlr removePreCtrol:(BOOL)removePreCtrol {
    
    if (self = [super init]) {
        _onInit = ^(){
//            [NTGDetection alertProcessViewWithStatus:[NTGDetection netStatus] detectionString:@"正在加载..." mode:MBProgressHUDModeIndeterminate];
        };
        _onSuccess = ^(id responseObject){
            
        };
        _onFail = ^(id responseObject){
            
        };
        _onFinish = ^(){};
        _onProgressBlock =^(id responseObject){};
        
        _onNeedLoginToken = ^(){
            if (removePreCtrol) {
                [navctlr popViewControllerAnimated:YES];
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
            NTGLoginController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
            [navctlr pushViewController:loginController animated:NO];
        };
    }
    return self;
}

- (instancetype)initWithNaVC:(UINavigationController*) navctlr removePreCtrol:(BOOL)removePreCtrol onSuccess:(BusinessSuccessBlock)success onFail:(BusinessFailBlock)fail{
    if (self = [super init]) {
        _onInit = ^(){
            
            
        };
        _onSuccess = ^(id responseObject){
            
        };
        _onFail = ^(id responseObject){
            NSLog(@"shibaile ");
            fail(responseObject);
            
        };
        _onFinish = ^(){};
        _onProgressBlock =^(id responseObject){};
        
        _onNeedLoginToken = ^(){
            if (removePreCtrol) {
                [navctlr popViewControllerAnimated:YES];
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
            NTGLoginController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
            [navctlr pushViewController:loginController animated:NO];
        };
    }
    return self;
}
- (NSString *)stringFromStatus:(NetworkStatus)status {
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

@end
