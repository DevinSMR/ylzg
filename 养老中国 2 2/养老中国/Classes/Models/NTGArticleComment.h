/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */


#import <Foundation/Foundation.h>
#import "NTGPraiseMembers.h"
@interface NTGArticleComment : NSObject
/**评论内容*/
@property (nonatomic,strong) NSString *content;
/**会员昵称*/
@property (nonatomic,strong) NSString *petName;
/**会员头像*/
@property (nonatomic,strong) NSString *picture;
/**评论时间*/
@property (nonatomic,strong) NSString *createDate;
/**评论数目*/
@property (nonatomic,strong) NSString *praiseNum;
/**点赞的用户*/
@property (nonatomic,strong) NSArray *praiseMembers;

@property (nonatomic,assign) long id;
-(CGFloat)commentCellHeight;
@end
