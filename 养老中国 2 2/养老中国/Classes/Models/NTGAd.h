/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>

/**
 * Entity - 广告
 *
 * @author nbcyl Team
 * @version 3.0
 */
@interface NTGAd : NSObject <NSCoding>

/** 标题 */
@property(nonatomic, copy) NSString *title;

/** 内容 */
@property(nonatomic, copy) NSString *content;

/** 路径 */
@property(nonatomic, copy) NSString *path;

/** 链接地址 */
@property(nonatomic, copy) NSString *url;

/** 广告联系人 */
@property(nonatomic, copy) NSString *contacts;

/** 联系人email */
@property(nonatomic, copy) NSString *contactEmail;

/** 联系人电话 */
@property(nonatomic, copy) NSString *contactsTel;

/* 在此处理图片动态压缩 720*260 */
//- (NSString*) getPathCompressPic;

@end
