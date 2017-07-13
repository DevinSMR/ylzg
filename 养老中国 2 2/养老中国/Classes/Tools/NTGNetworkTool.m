/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#define YGErrorDomainName  @"cn.tianmabang.error.network"
#import "NTGNetworkTool.h"
#import "zlib.h"
#import "LFCGzipUtillity.h"
#import "NTGCookies.h"
#import "NTGBusinessResult.h"
#import "NTGDetection.h"
#import "Reachability.h"
#import <AFNetworking.h>

//typedef void(^SKNetFinishedCallBack)(ResultBlock resultblock,ErrorBlock errorblock);

/**
 * tool - 封装AFN
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGNetworkTool

+ (instancetype)sharedNetworkTool {
    
    static NTGNetworkTool *instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
     
        instance = [[self alloc] initWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        instance.responseSerializer =[AFHTTPResponseSerializer serializer];
        instance.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
    });
    return instance;
}


/** 调用接口参数非二进制数据 */
/*- (void)requestMethod:(YGNetworkMethod)method urlString:(NSString *)UrlString params:(NSDictionary *)dict  result:(NTGBusinessResult *)result {
    [self requestMethod:method urlString:UrlString params:dict multipartFormData:nil result:result];
}*/


/**
 网络请求
 */
- (void)requestMethod:(YGNetworkMethod)method urlString:(NSString *)UrlString params:(NSDictionary *)dict multipartFormData:(NSDictionary *)multipartFormData result:(NTGBusinessResult *)result{
    
    // 成功的Block
    void (^success)(NSURLSessionDataTask *task, id responseObject) = ^ (NSURLSessionDataTask *task, id responseObject){
        [NTGCookies saveCookies];      
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"正常返回数据");
            if (result.onInnerSuccessWrapper) {
                result.onInnerSuccessWrapper(responseObject);
            }
            result.onFinish();
            
        }else if ([responseObject isKindOfClass:[NSData class]]){
           
            NSData *respAfterUncompressByte = [LFCGzipUtillity uncompressZippedData:responseObject];
            
            NSString* aStr= [[NSString alloc] initWithData:respAfterUncompressByte   encoding:NSUTF8StringEncoding];
            NSLog(@"%@", aStr);
            id r = [NSJSONSerialization JSONObjectWithData:respAfterUncompressByte options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *nsdic = (NSDictionary *) r;
            
            int code = [[nsdic objectForKey:@"code"] intValue];
            if (1 == code) {
                id data = [nsdic objectForKey:@"data"];
                result.onInnerSuccessWrapper(data);
                result.onFinish();
            }else if(0 == code){
                result.onFinish();
                result.onFail(@"无效的访问");
            }
            else if(5 == code){
                id desc = [[nsdic objectForKey:@"desc"] objectForKey:@"desc"];
                
                result.onFinish();
                result.onFail(desc);
            } else {
                //弹出登录框
                result.onFinish();
                result.onNeedLoginToken();
            }
        }else {
            NSLog(@"网络单例请求到空数据");
            result.onFinish();
        }
    };
    
    // 失败的Block
    void(^failed)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        NSLog(@"网络单例未能请求到数据，请求返回错误");
//        if (result.onFail) {
//            result.onFail(@"");
//            //errorblock(error);
//        }
        NSNotification *notification =[NSNotification notificationWithName:@"NTGRequestError" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

        result.onFail(@"");
    };
    
    if (![UrlString hasPrefix:@"http://"]) {
        
        //内部网络
    // NSString * baseUrl = @"http://192.168.2.241:7075/ylzgnetapp";
        //外部网络
       NSString * baseUrl = @"http://www.ylzgnet.com/ylzgnetapp";
        
        
        UrlString = [baseUrl stringByAppendingString:UrlString];
    }
    NSString *tempUrl = [NSString stringWithFormat:@"URL:%@",UrlString];
    NSLog(@"%@",tempUrl);
    //检测网络状态
    if ([NTGDetection netStatus] == NotReachable) {
        result.onFail(@"");
        return;
    }
    result.onInit();
    [NTGCookies loadCookies];
    switch (method) {
        case YGNetworkMethodGET:
            [self GET:UrlString parameters:dict success:success failure:failed];
            break;
        case YGNetworkMethodPOST:
            //[self POST:UrlString parameters:dict success:success failure:failed];
            [self POST:UrlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                NSArray *keys = [multipartFormData allKeys];
                for (int i=0; i<keys.count; i++) {
                    NSString *aKey = (NSString *)keys[i];
                    NSString *aValue = [multipartFormData objectForKey:aKey];
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:aValue] name:aKey error:nil];
                }
            }
            success:success
            failure:failed];
            break;
        //default:
            //break;
    }
    
}

@end
