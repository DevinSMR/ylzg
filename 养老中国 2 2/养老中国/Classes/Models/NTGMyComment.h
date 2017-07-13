//
//  NTGMyComment.h
//  养老中国
//
//  Created by nbc on 16/8/31.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTGArticle.h"
#import "NTGMember.h"
@interface NTGMyComment : NSObject

/** 创建时间 */
@property(nonatomic,copy) NSString *createDate;

/** "评论的ID"  */
@property(nonatomic,assign) long id;

/** 评论的文章 */
@property(nonatomic,copy) NSDictionary *memberArticle;

/** 评论的内容 */
@property(nonatomic,copy) NSString *content;

@property (nonatomic,strong) NTGMember *member;


@end
