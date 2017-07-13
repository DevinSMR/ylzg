

//
//  NTGRelatedArticle.m
//  养老中国
//
//  Created by nbc on 16/8/26.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGRelatedArticle.h"
#import "NTGArticle.h"
@implementation NTGRelatedArticle
+(NSDictionary *)mj_objectClassInArray{
    return @{
             
             @"data" : [NTGArticle class]
             
             };
    
}

@end
