/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * tool - 网络业务回调
 *
 * @author nbcyl Team
 * @version 3.0
 */

typedef void(^BusinessInitBlock)();
typedef void(^BusinessSuccessBlock)(id responseObject);
typedef void(^BusinessFailBlock)(id responseObject);
typedef void(^BusinessProgressBlock)(id responseObject);
typedef void(^BusinessFinishBlock)();
typedef void(^BusinessNeedLoginTokenBlock)();



/** 调用块封装 ： 内部使用 */


/**
 业务回调接口
 */
@interface NTGBusinessResult : NSObject

/** 发送请求前执行执行此回调 */
@property(nonatomic,copy) void(^onInit)() ;

/** 成功获取数据后，调用此回调 */
@property(nonatomic,copy) void(^onSuccess)(id);

/** 需要登录凭证 */
@property(nonatomic,copy) void(^onNeedLoginToken)() ;

/** 失败获取数据后，调用此回调 */
@property(nonatomic,copy) void(^onFail)(id) ;

/** 数据处理进度 */
@property(nonatomic,copy) void(^onProgressBlock)(id) ;

/** 操作完成后执行此回调 */
@property(nonatomic,copy) void(^onFinish)() ;

/** 不要修改此属性： 封装成功调用块，内部需封装字典转对象 内部使用 */
@property(nonatomic,copy) void(^onInnerSuccessWrapper)(id) ;





- (instancetype)initWithNavController:(UINavigationController*) navctlr removePreCtrol:(BOOL) removePreCtrol;
- (instancetype)initWithNavController:(UINavigationController*) navctlr;

- (instancetype)initWithNaVC:(UINavigationController*) navctlr removePreCtrol:(BOOL)removePreCtrol onSuccess:(BusinessSuccessBlock)success onFail:(BusinessFailBlock)fail;


@end
