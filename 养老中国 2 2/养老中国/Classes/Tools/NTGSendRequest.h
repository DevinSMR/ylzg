/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>
#import "NTGBusinessResult.h"
typedef void(^BusinessResultBlock)(id responseObject);
//typedef void(^BusinessErrorBlock)(NSError *error);

/**
 * control - 业务请求帮助类 
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGSendRequest : NSObject
/** 根据广告位获取广告 */
+ (void)getAdWithPosition:(NSDictionary *)params success:(NTGBusinessResult *) sb;
/** 1.最新频道Banner */
+ (void)getLastestBanner:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 最新频道文章列表 */
+ (void)getListLastest:(NSDictionary *)params success:(NTGBusinessResult *) sb;
/** 最新,新闻，文化，科技频道文章详情 */
+ (void)getArticleDetail:(NSString *)articleUrl success:(NTGBusinessResult *) sb;

/** 文章评论列表 */
+ (void)getArticleComment:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 相关新闻列表 */
+ (void)getArticleRelated:(NSDictionary *)params success:(NTGBusinessResult *) sb;



/** 2.新闻频道Banner */
+ (void)getNewsBanner:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 新闻频道文章列表 */
+ (void)getListNews:(NSDictionary *)params success:(NTGBusinessResult *) sb;
/** 3.文化频道Banner */
+ (void)getCultureBanner:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 文化频道文章列表 */
+ (void)getlistCulture:(NSDictionary *)params success:(NTGBusinessResult *) sb;
/** 4.科技频道Banner */
+ (void)getTechnologyBanner:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 科技频道文章列表 */
+ (void)getListTechnology:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 5.图片频道列表 */
+ (void)getListPictures:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 6.视频频道列表 */
+ (void)getListVideos:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 关键词搜索 */
+ (void)getSearchArticle:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 热门关键词 */
+ (void)getHotSearchWords:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 校验用户是否已存在 */
+ (void)registerCheck_mobile:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 发送短信验证码 */
+ (void)getSMSValidCode:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 校验短信验证码有效性 */
+ (void)registercheck_SMSValidCode:(NSDictionary *)params success:(NTGBusinessResult *)sb;
/** 注册 */
+ (void)registerSubmit:(NSDictionary *)params success:(NTGBusinessResult *)sb;
/** 获取公钥网络请求 */
+ (void)getPublicKey:(NSDictionary *)params success:(BusinessResultBlock) sb;

/** 登陆接口网路请求 */
+ (void) login:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 更新用户资料 */
+ (void)getUpdateMember:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 用户注销 */
+ (void)loginOut:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 更新用户头像 */
+ (void)getUpdateMemberHead:(NSDictionary *)params multipartFormData:(NSDictionary *)multipartFormData success:(NTGBusinessResult *)sb;


/** 修改密码 */
+ (void)getUpdatePassword:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 查看用户资料 */
+ (void)getMyProfile:(NSDictionary *)params multipartFormData:(NSDictionary *)multipartFormData success:(NTGBusinessResult *)sb;

/** 点赞或者取消点赞*/
+(void)setPraise:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 收藏或者取消收藏*/

+ (void)favoriteAdd:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 发表评论*/

+ (void)publishComment:(NSDictionary *)params success:(NTGBusinessResult *)sb;
/** 评论点赞或者取消点赞 */
+(void)setCommentPraise:(NSDictionary *)params success:(NTGBusinessResult *)sb;

/** 我的收藏列表 */
+ (void)getlistfavorite:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 我的评论列表 */
+ (void)getlistComment:(NSDictionary *)params success:(NTGBusinessResult *) sb;


/** 取消收藏 */
+ (void)cancelFavorite:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 删除评论 */
+ (void)deleteComment:(NSDictionary *)params success:(NTGBusinessResult *) sb;


/** 反馈信息 */
+ (void)getfeedback:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 第三方登录 */
+ (void)thirdPartylogin:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 检测昵称是否可用 */
+ (void)checkPetName:(NSDictionary *)params success:(NTGBusinessResult *) sb;

/** 版本比对 */
+ (void)checkVersion:(NSDictionary *)params success:(NTGBusinessResult *) sb;




@end
