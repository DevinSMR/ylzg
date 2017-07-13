/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */


#import "NTGArticleComment.h"

/**
 * Entity - 文章评论
 *
 * @author nbcyl Team
 * @version 3.0
 */
@implementation NTGArticleComment
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             
             @"petName" : @"member.petName",
             @"picture" : @"member.picture"
             };
}
+(NSDictionary *)mj_objectClassInArray{
    return @{
             
             @"praiseMembers" : [NTGPraiseMembers class]
             
             };

}
-(CGFloat)commentCellHeight{
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 66, MAXFLOAT);
    // 计算内容label的高度
    CGFloat textH = [self.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    return 93 + textH;
    
}

@end
