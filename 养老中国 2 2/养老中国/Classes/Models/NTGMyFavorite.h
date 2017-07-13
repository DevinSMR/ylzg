//
//  NTGMyFavorite.h
//  养老中国
//
//  Created by nbc on 16/11/28.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTGArticle.h"
@interface NTGMyFavorite : NSObject
/** 创建时间 */
@property(nonatomic,copy) NSString *createDate;

/** "文章的ID"  */
@property(nonatomic,assign) long id;

/** 更改的时间 */
@property(nonatomic,copy) NSString *modifyDate;


/**收藏的文章*/
@property (nonatomic,strong) NTGArticle *article;

@end
