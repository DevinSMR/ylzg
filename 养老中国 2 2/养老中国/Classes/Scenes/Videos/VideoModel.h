
/*!
 @header VideoModel.h
 
 @abstract  作者Github地址：https://github.com/zhengwenming
            作者CSDN博客地址:http://blog.csdn.net/wenmingzheng
 
 @author   Created by zhengwenming on  16/1/20
 
 @version 1.00 16/1/20 Creation(版本信息)
 
   Copyright © 2016年 郑文明. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
//@property (nonatomic, strong) NSString * cover;
//@property (nonatomic, strong) NSString * descriptionDe;
//@property (nonatomic, assign) NSInteger  length;
//@property (nonatomic, strong) NSString * m3u8_url;
//@property (nonatomic, strong) NSString * m3u8Hd_url;
//@property (nonatomic, strong) NSString * mp4_url;
//@property (nonatomic, strong) NSString * mp4_Hd_url;
//@property (nonatomic, assign) NSInteger  playCount;
//@property (nonatomic, strong) NSString * playersize;
//@property (nonatomic, strong) NSString * ptime;
//@property (nonatomic, strong) NSString * replyBoard;
//@property (nonatomic, strong) NSString * replyCount;
//@property (nonatomic, strong) NSString * replyid;
//@property (nonatomic, strong) NSString * title;
//@property (nonatomic, strong) NSString * vid;
//@property (nonatomic, strong) NSString * videosource;

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




@end
