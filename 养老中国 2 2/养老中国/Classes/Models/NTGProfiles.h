//
//  NTGProfiles.h
//  养老中国
//
//  Created by nbc on 16/8/19.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTGProfiles : NSObject
/**用户性别*/
@property(nonatomic,copy) NSString *gender;

/** 用户名 */
@property(nonatomic,copy) NSString *username;

/** "用户id" 名称 */
@property(nonatomic,assign) long id;

/** "头像" 原图 */
@property(nonatomic,copy) NSString *picture;

/** 电话 */
@property(nonatomic,copy) NSString *mobile;

/**会员昵称*/
@property (nonatomic,strong) NSString *petName;

@end
