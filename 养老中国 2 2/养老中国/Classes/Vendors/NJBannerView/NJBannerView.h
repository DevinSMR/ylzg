//
//  NJBannerView.h
//  BannerViewDemo
//
//  Created by JLee Chen on 16/6/27.
//  Copyright © 2016年 JLee Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTGArticle.h"
@protocol NJBannerViewDataSource <NSObject>

@optional
- (UIPageControl *)pageControlOfNJBannerView;

@end

@interface NJBannerView : UIView

/**
 *  datas:字典数组，key:img,value:本地图片名或网络图片地址
 */
@property (copy , nonatomic) NSMutableArray *datas;
/**
 *  点击图片回调事件
 */
@property (copy , nonatomic) void(^linkAction)(NTGArticle *article);

//未显示页颜色，默认灰色
@property (copy , nonatomic) UIColor *pageIndicatorTintColor;
//当前显示页的颜色，默认白色
@property (copy , nonatomic) UIColor *currentPageIndicatorTintColor;

@property (copy , nonatomic) UIImage *placeholderImg;
@property (weak , nonatomic) id<NJBannerViewDataSource> dataSouce;
//图片滚动间隔,默认为2.0秒
@property (assign , nonatomic) CGFloat intervalTime;
//是否需要自动滚动,默认为YES
@property (assign , nonatomic) BOOL isNeedAutoScroll;
//顶部搜索框
@property (nonatomic,strong) UIButton *searchBar;


- (id) initWithFrame:(CGRect)frame placeholderImg:(UIImage *) placeholderImg;
@end
