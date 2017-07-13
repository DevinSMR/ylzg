/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGCookies.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>

/**
 * tool - cookies
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGCookies



/** 保存从服务器获取的所有cookies */
+ (void) saveCookies {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *cookieDictionary = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:@"kLocalCookieName"]];
    
    //每次请求获取到的COOKIE
    NSArray *allcookies =[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in allcookies) {
        [cookieDictionary setValue:cookie.properties forKey:cookie.name];
        //以kLocalCookieName为KEY写入本地
    }
    
    [defaults setObject:cookieDictionary forKey:@"kLocalCookieName"];
    [defaults synchronize];
}


/** 获取所有保存在用户端的COOKIE,并写入内存 */
+ (void) loadCookies {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *allCookiesDict = [defaults valueForKey:@"kLocalCookieName"];
    
    NSArray *allCookiesNames = allCookiesDict.allKeys;
    for (NSString *name in allCookiesNames) {
        NSDictionary *aCookieDict = [allCookiesDict valueForKey:name];
        NSHTTPCookie *aCookie = [NSHTTPCookie cookieWithProperties:aCookieDict];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:aCookie];
        //NSLog(@"COOKIES:%@", aCookie);
    }
    
}

@end
