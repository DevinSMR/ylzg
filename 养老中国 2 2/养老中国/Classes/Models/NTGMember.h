/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>

/**
 * Entity - 会员
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGMember : NSObject <NSCoding>


/**用户性别*/
@property(nonatomic,copy) NSString *gender;

/** 用户名 */
@property(nonatomic,copy) NSString *username;

/** "用户id" 名称 */
@property(nonatomic,assign) long userid;

/** "头像" 原图 */
@property(nonatomic,copy) NSString *pictureOrg;

/** "头像" 中图 */
@property(nonatomic,copy) NSString *pictureMid;

/** "头像" 小图 */
@property(nonatomic,copy) NSString *pictureSml;

/** 昵称 */
@property(nonatomic,copy) NSString *petName;


@end
