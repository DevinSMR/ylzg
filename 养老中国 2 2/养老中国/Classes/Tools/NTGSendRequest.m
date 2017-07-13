/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGSendRequest.h"

#import "NTGNetworkTool.h"
#import <MJExtension.h>
#import "NTGAd.h"
#import "NTGAdPosition.h"
#import "NTGPage.h"
#import "NTGArticle.h"
#import "NTGMBProgressHUD.h"
#import "NTGMember.h"
#import "NTGArticleComment.h"
#import "NTGProfiles.h"
#import "NTGRelatedArticle.h"
#import "NTGMyComment.h"
#import "NTGMyFavorite.h"
#import <UIKit/UIKit.h>
/**
 * control - 业务请求帮助类
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGSendRequest
/** 根据广告位获取广告 */
+ (void)getAdWithPosition:(NSDictionary *)params success:(NTGBusinessResult *)sb  {
    
    void(^s)(id responseObject) = ^(id responseObject) {
        
        NTGAdPosition * adPosition = [NTGAdPosition mj_objectWithKeyValues : responseObject];
        sb.onSuccess(adPosition);
    };
    
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/adPosition/list.jhtml" params:params result:s error:nil];
}

/** 最新频道banner*/
+(void)getLastestBanner:(NSDictionary *)params success:(NTGBusinessResult *)sb
{
    
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
           };
    
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/latestBanner.jhtml" params:params result:s error:nil];
}
/** 最新频道文章列表 */
+ (void)getListLastest:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
//
    };
   [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/listLatest.jhtml" params:params result:s error:nil];

}


/** 最新,新闻，文化，科技频道文章详情 */
+ (void)getArticleDetail:(NSString *)articleUrl success:(NTGBusinessResult *) sb
{

    void(^s)(id responseObject) = ^(id responseObject) {
        NTGArticle *article = [NTGArticle mj_objectWithKeyValues:responseObject];
        sb.onSuccess(article);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:articleUrl params:nil result:s error:nil];
}

/** 文章评论列表 */
+ (void)getArticleComment:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticleComment class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        sb.onSuccess(page);

    
    };
    
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/memberComments.jhtml" params:params result:s error:nil];



}
/** 相关新闻列表 */
+ (void)getArticleRelated:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    void(^s)(id responseObject) = ^(id responseObject) {
        NSArray *page = [NTGArticle mj_objectArrayWithKeyValuesArray:responseObject];
        sb.onSuccess(page);
    };
    
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/recomment.jhtml" params:params result:s error:nil];
}

/** 新闻频道banner*/
+(void)getNewsBanner:(NSDictionary *)params success:(NTGBusinessResult *)sb
{
    
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
    };
    
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/newsBanner.jhtml" params:params result:s error:nil];
}

/** 新闻频道文章列表 */
+ (void)getListNews:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/listNews.jhtml" params:params result:s error:nil];
}

/** 文化频道banner */
+ (void)getCultureBanner:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/cultureBanner.jhtml" params:params result:s error:nil];
}

/** 文化频道文章列表 */
+ (void)getlistCulture:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/listCulture.jhtml" params:params result:s error:nil];
}

/** 科技频道banner */
+ (void)getTechnologyBanner:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/technologyBanner.jhtml" params:params result:s error:nil];
}

/** 科技频道文章列表 */
+ (void)getListTechnology:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/listTechnology.jhtml" params:params result:s error:nil];
}

/** 图片频道列表 */
+ (void)getListPictures:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/pictureChannel.jhtml" params:params result:s error:nil];
}

/** 视频频道列表 */
+ (void)getListVideos:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/mediaChannel.jhtml" params:params result:s error:nil];
}

/** 关键词搜索 */
+ (void)getSearchArticle:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGArticle class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/overallSearch.jhtml" params:params result:s error:nil];

}


/** 热门关键词 */
+ (void)getHotSearchWords:(NSDictionary *)params success:(NTGBusinessResult *) sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        sb.onSuccess(array);
    };
    
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/article/hotSearchWords.jhtml" params:params result:s error:nil];
}



/** 校验用户是否已存在 */
+ (void)registerCheck_mobile:(NSDictionary *)params success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/register/check_mobile.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 发送短信验证码 */
+ (void)getSMSValidCode:(NSDictionary *)params success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/common/get_SMSValidCode.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 校验短信验证码有效性 */
+ (void)registercheck_SMSValidCode:(NSDictionary *)params success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/common/check_SMSValidCode.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 注册 */
+ (void)registerSubmit:(NSDictionary *)params success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/register/submit4Ios.jhtml" params:params innerSuccessWrapper:s result:sb];
}


/** 获取公钥网络请求 */
+ (void)getPublicKey:(NSDictionary *)params success:(BusinessResultBlock) sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        //声明数组元素的对象类型
        NSString *r =  (NSString *)responseObject;
        sb(r);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/common/publicKey.jhtml" params:params result:s error:nil];
    
}

/** 登陆接口网路请求 */
+ (void) login:(NSDictionary *)params success:(NTGBusinessResult *)sb {
    //字典转对象
    void(^s)(id responseObject) = ^(id responseObject) {
        NTGMember * member = [NTGMember mj_objectWithKeyValues:responseObject];
        if (member) {
            sb.onSuccess(member);
        }else {
            sb.onFail(responseObject);
        }
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/login/login4Ios.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 用户注销 */
+ (void)loginOut:(NSDictionary *)params success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/logout.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 更新用户资料 */
+ (void)getUpdateMember:(NSDictionary *)params success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/member/profile/updateMember.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 更新用户头像 */
+ (void)getUpdateMemberHead:(NSDictionary *)params multipartFormData:(NSDictionary *)multipartFormData success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/member/profile/updateMemberHead.jhtml" params:params multipartFormData:multipartFormData innerSuccessWrapper:s result:sb];
}


/** 修改密码 */
+ (void)getUpdatePassword:(NSDictionary *)params success:(NTGBusinessResult *)sb{
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/password/findPassword.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 查看用户资料 */
+ (void)getMyProfile:(NSDictionary *)params multipartFormData:(NSDictionary *)multipartFormData success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        NTGProfiles *profile = [NTGProfiles mj_objectWithKeyValues:responseObject];
        sb.onSuccess(profile);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/member/profile/view.jhtml" params:params multipartFormData:multipartFormData innerSuccessWrapper:s result:sb];
}

/** 点赞或者取消点赞 */
+(void)setPraise:(NSDictionary *)params success:(NTGBusinessResult *)sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        NSString *str = [responseObject stringValue];
        sb.onSuccess(str);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/member/praise/addOrDelete.jhtml" params:params innerSuccessWrapper:s result:sb];

}

/** 收藏或者取消收藏 */
+ (void)favoriteAdd:(NSDictionary *)params success:(NTGBusinessResult *)sb {
    void(^s)(id responseObject) = ^(id responseObject) {
        NSString *str = [responseObject stringValue];
        sb.onSuccess(str);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/member/favorite/addOrDelete.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 发表评论*/

+ (void)publishComment:(NSDictionary *)params success:(NTGBusinessResult *)sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/member/memberComment/saveComment.jhtml" params:params innerSuccessWrapper:s result:sb];

}

/** 评论点赞或者取消点赞 */
+(void)setCommentPraise:(NSDictionary *)params success:(NTGBusinessResult *)sb
{
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/member/commentPraise/addOrDelete.jhtml" params:params innerSuccessWrapper:s result:sb];
    
}


/** 我的收藏列表 */
+ (void)getlistfavorite:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGMyFavorite class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
        //
    };
   // [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/member/favorite/list.jhtml" params:params result:s error:nil];
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/member/favorite/list.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 我的评论列表 */
+ (void)getlistComment:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    void(^s)(id responseObject) = ^(id responseObject) {
        [NTGPage mj_setupObjectClassInArray : ^NSDictionary *{
            return @{
                     @"content" : [NTGMyComment class]
                     };
        }];
        NTGPage *page = [NTGPage mj_objectWithKeyValues:responseObject];
        
        
        sb.onSuccess(page);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/member/memberComment/list.jhtml" params:params innerSuccessWrapper:s result:sb];}


/** 取消收藏 */
+ (void)cancelFavorite:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
        //
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/member/favorite/delete.jhtml" params:params innerSuccessWrapper:s result:sb];}

/** 删除评论 */
+ (void)deleteComment:(NSDictionary *)params success:(NTGBusinessResult *) sb;{
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
        
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/member/memberComment/deleteComment.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 反馈信息 */
+ (void)getfeedback:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    
        void(^s)(id responseObject) = ^(id responseObject) {
            sb.onSuccess(responseObject);
            
        };
        [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/feedback/save.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 第三方登录 */
+ (void)thirdPartylogin:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    void(^s)(id responseObject) = ^(id responseObject) {
        NTGMember *profile = [NTGMember mj_objectWithKeyValues:responseObject];
        sb.onSuccess(profile);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodPOST urlString:@"/login/thirdPartylogin.jhtml" params:params innerSuccessWrapper:s result:sb];
}

/** 检测昵称是否可用 */
+ (void)checkPetName:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/register/check_petName.jhtml" params:params innerSuccessWrapper:s result:sb];
}


/** 版本比对 */
+ (void)checkVersion:(NSDictionary *)params success:(NTGBusinessResult *) sb{
    
    void(^s)(id responseObject) = ^(id responseObject) {
        sb.onSuccess(responseObject);
    };
    [NTGSendRequest sendHttpRequest:YGNetworkMethodGET urlString:@"/about/version.jhtml" params:params innerSuccessWrapper:s result:sb];
}




/** 网路请求 */
+ (void)sendHttpRequest:(YGNetworkMethod)method urlString:(NSString *)UrlString params:(NSDictionary *)dict result:(ResultBlock)resultblock error:(ErrorBlock)errorblock {
    NTGBusinessResult* result = [[NTGBusinessResult alloc] initWithNavController:nil];
    [NTGSendRequest  sendHttpRequest:method urlString:UrlString params:dict innerSuccessWrapper:resultblock result:result];
}

/** 不需要传递二进制数据(文件)，调用此接口 */
+ (void)sendHttpRequest:(YGNetworkMethod)method urlString:(NSString *)UrlString params:(NSDictionary *)dict innerSuccessWrapper:(BusinessResultBlock)innerSuccessWrapper result:(NTGBusinessResult *)resultblock {
    resultblock.onInnerSuccessWrapper = innerSuccessWrapper;
    [NTGSendRequest sendHttpRequest:method urlString:UrlString params:dict multipartFormData:nil innerSuccessWrapper:innerSuccessWrapper result:resultblock];
}

/** 传递各种类型的数据，包含文件  */
+ (void)sendHttpRequest:(YGNetworkMethod)method urlString:(NSString *)UrlString params:(NSDictionary *)dict multipartFormData:(NSDictionary *)multipartFormData innerSuccessWrapper:(BusinessResultBlock)innerSuccessWrapper result:(NTGBusinessResult *)resultblock {
    resultblock.onInnerSuccessWrapper = innerSuccessWrapper;
    [[NTGNetworkTool sharedNetworkTool] requestMethod:method urlString:UrlString params:dict  multipartFormData:multipartFormData result:resultblock];
}




@end
