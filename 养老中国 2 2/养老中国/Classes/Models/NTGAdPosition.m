//
//  NTGAdPosition.m
//  test
//
//  Created by luozhuang on 15-11-15.
//  Copyright (c) 2015年 luozhuang. All rights reserved.
//

#import "NTGAdPosition.h"
#import "NTGAd.h"
#import <MJExtension.h>

@implementation NTGAdPosition

//MJCodingImplementation
//告诉编译器：openAds这个属性里的元素都是NTGAd这个类
+ (NSDictionary *)objectClassInArray{
    return @{
             @"ads":[NTGAd class]
            };
    
}

-(void)encodeWithCoder:(NSCoder *) coder{
    
    [coder encodeObject:_ads forKey:@"ads"];
}

-(id)initWithCoder:(NSCoder *)  decoder{
    if(self =[super init]){
        
        self.ads=[decoder decodeObjectForKey:@"ads"];
    }
    return (self);
}
@end
