//
//  NTGArticle.h
//  养老中国
//
//  Created by nbc on 16/7/20.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTGArticle : NSObject<NSCoding>
/**
 * Entity - 用户文章
 *
 * @author nbcyl wangwei
 * @version 1.0
 */



/** id */
@property(nonatomic,assign) long id;

/** 标题 */
@property(nonatomic,copy) NSString *title;

/** 内容 */
@property(nonatomic,copy) NSString *content;

/** 摘要 */
@property(nonatomic,copy) NSString *paper;

/** 形式 */
@property(nonatomic,copy) NSString *tagType;


/** 创建时间 */
@property(nonatomic,copy) NSString *createDate;

/** 文章详情接口地址 */
@property(nonatomic,copy) NSString *path;

/** 图片路径 */
@property(nonatomic,copy) NSString *image;

/** 显示时间 */
@property(nonatomic,copy) NSString *displayTime;

/** 文章来源 */
@property(nonatomic,copy) NSString *articleSourceName;

/** 关键字 */
@property(nonatomic,copy) NSString *articleTag;

/** 图片集合 */
@property(nonatomic,copy) NSArray *articleImage;

/** 视频地址 */
@property(nonatomic,copy) NSString *media;

/** 视频图片 */
@property(nonatomic,copy) NSString *mediaImage;

/** 是否点赞 */
@property(nonatomic,assign) id isPraise;

/** 是否收藏 */
@property(nonatomic,assign) id isFavorite;

/** 点赞的个数 */
@property(nonatomic,copy) NSString *praiseNum;

/** 选中状态 */
@property(nonatomic,assign) BOOL tag;

/** 真实文章 */
@property(nonatomic,copy) NSString *realContent;

/** 第三方分享链接 */
@property(nonatomic,copy) NSString *sharePath;

/** 第三方视频链接 */
@property(nonatomic,copy) NSString *links;


@end
