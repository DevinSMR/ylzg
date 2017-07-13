/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>

/**
 * tool - 检索手机号、邮箱、身份证
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGValidateMobile : NSObject

#pragma mark - 判断是否是手机号
+ (BOOL)validateMobile:(NSString *)phoneNumber;

#pragma mark - 判断是否是邮箱
+ (BOOL)validateEmail:(NSString *)email;

#pragma 正则匹配用户身份证号15或18位
//+ (BOOL)checkUserIdCard:(NSString *)idCard;
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
@end
