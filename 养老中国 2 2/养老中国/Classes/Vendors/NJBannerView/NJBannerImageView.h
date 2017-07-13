//
//  NJBannerImageView.h
//  BannerViewDemo
//
//  Created by JLee Chen on 16/6/27.
//  Copyright © 2016年 JLee Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTGArticle.h"
@interface NJBannerImageView : UIControl

@property (copy , nonatomic) NSDictionary *dicProperty;
@property (copy , nonatomic) void(^linkAction)(NTGArticle *article);

@property (copy , nonatomic) UIImage *placeholderImg;


@end
