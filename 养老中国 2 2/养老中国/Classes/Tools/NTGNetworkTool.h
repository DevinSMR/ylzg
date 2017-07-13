/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>
#import "NTGBusinessResult.h"

/**
 * tool - 封装AFN
 *
 * @author nbcyl Team
 * @version 3.0
 */

typedef NS_ENUM(NSInteger, YGNetworkMethod) {
    YGNetworkMethodGET = 0,
    YGNetworkMethodPOST,
};
typedef void(^ResultBlock)(id responseObject);
typedef void(^ErrorBlock)(NSError *error);

#import <AFNetworking.h>

@interface NTGNetworkTool : AFHTTPSessionManager

/**
 *  网络访问单例
 *  @return NetworkTool单例
 */
+ (instancetype)sharedNetworkTool;

/**
 *  网络请求，封装了GET和POST
 *
 *  @param method      枚举，GET/POST
 *  @param UrlString   baseURL之后的地址
 *  @param multipartFormData 如果需要传递二进制数据（文件等），则使用此参数
 *  @param result 服务调用结果回调
 */

- (void)requestMethod:(YGNetworkMethod)method urlString:(NSString *)UrlString params:(NSDictionary *)dict multipartFormData:(NSDictionary *)multipartFormData result:(NTGBusinessResult *)result;

@end
