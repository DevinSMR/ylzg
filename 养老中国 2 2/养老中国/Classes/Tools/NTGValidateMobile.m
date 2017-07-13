/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGValidateMobile.h"

/**
 * tool - 检索手机号、邮箱、身份证
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGValidateMobile

#pragma mark - 判断是否是手机号码
+ (BOOL)validateMobile:(NSString *)phoneNumber {
    NSString * mobile = @"^((\\+{0,1}86){0,1})1[3-8]{1}\\d{9}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return [predicate evaluateWithObject:phoneNumber];
}

#pragma mark - 判断是否是邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *validate = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validate];
    return [predicate evaluateWithObject:email];
}

#pragma 正则匹配用户身份证号15或18位
//+ (BOOL)checkUserIdCard:(NSString *)idCard {
//    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|xX)$)";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    return [pred evaluateWithObject:idCard];
//}
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

@end
