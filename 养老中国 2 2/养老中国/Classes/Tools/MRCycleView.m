//
//  MRCycleView.m
//  CycleScrollViewDemo
//
//  Created by lanou3g on 16/4/19.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "MRCycleView.h"
#import <UIImageView+WebCache.h>
@interface MRCycleView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *imgScrollView;
@property (nonatomic,strong) UIPageControl *imgPageControl;
//imageView数组
@property (nonatomic,strong) NSMutableArray *imgViewArray;
//存放图片的数组
@property (nonatomic,strong) NSMutableArray *imgArray;
//当前展示的图片下标
@property (nonatomic,assign) NSInteger index;
//NSTimer
@property (nonatomic,strong) NSTimer *imgTimer;
//点击回调block
@property (nonatomic,copy) void(^tapBlock)(NSInteger index);
//时间间隔
@property (nonatomic,assign) NSTimeInterval interval;
@end
@implementation MRCycleView
-(instancetype)initWithFrame:(CGRect)frame Intervar:(NSTimeInterval)interval
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgViewArray = [NSMutableArray new];
        self.imgArray = [NSMutableArray new];
        //这个地方必须是bounds,如果这个类的frame不是从(0,0)开始,那么ScrollView也会相应的根据frame的改变而改变,从而造成超出view范围的情况
        self.imgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.imgScrollView.contentSize = CGSizeMake(frame.size.width * 3,frame.size.height );
        [self addSubview:self.imgScrollView];
        for (int i = 0; i < 3; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
            [self.imgScrollView addSubview:imgView];
         
            [self.imgViewArray addObject:imgView];
        }
        
        self.imgScrollView.pagingEnabled = YES;
        self.imgScrollView.showsHorizontalScrollIndicator = NO;
        self.imgScrollView.delegate = self;
        self.interval = interval;
        
    }
    return self;

}
//图片滚动方法
-(void)timerAction{
    [self.imgScrollView setContentOffset:CGPointMake(self.imgScrollView.frame.size.width * 2, 0) animated:YES];
    self.index = (self.index + 1) % self.imgNameArray.count;
    

}
//滚动动画结束
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //回位
    [self.imgScrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
    [self layoutImages];

}
//图片名数组setter
-(void)setImgNameArray:(NSMutableArray *)imgNameArray
{
    if (_imgNameArray != imgNameArray) {
        _imgNameArray = imgNameArray;
        NSLog(@"%@",_imgNameArray);
        [self.imgPageControl removeFromSuperview];
        self.imgPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
        [self addSubview:self.imgPageControl];
        self.imgPageControl.currentPage = 0;
        self.imgPageControl.numberOfPages = _imgNameArray.count;
        //关闭交互
        self.imgPageControl.enabled = NO;
        
                for (int i = 0; i < imgNameArray.count; i++) {
            NSString *imgURl = imgNameArray[i];
            
            [self.imgArray addObject:imgURl];
            if (i < 3) {
                
                [self.imgViewArray[i] sd_setImageWithURL:[NSURL URLWithString:imgURl]];
            }

        }
        //设置当前偏移量
      [self.imgScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
       self.index = 0;
      [self layoutImages];
        //点击手指
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCycleViewAction:)];
        [(UIImageView *)self.imgViewArray[1] addGestureRecognizer:tap];
        //打开交互
        [(UIImageView *)self.imgViewArray[1] setUserInteractionEnabled:YES];
        
        //初始化NSTimer
        if (self.interval <= 0) {
            self.imgTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            
        }else{
            self.imgTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }
        
    }

}
-(void)tapCycleViewAction:(UITapGestureRecognizer *)tap{
    if (self.tapBlock) {
        self.tapBlock(self.index);
    }

}
#pragma mark - UIScrollViewDelegate
static CGFloat x = 0;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    x = scrollView.contentOffset.x;
    //未来执行,一直都是未来得不到执行
    [self.imgTimer setFireDate:[NSDate distantFuture]];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (x > scrollView.contentOffset.x) {
        //向右划展示左边的图片
        [self panToleft:NO Index:self.index];
    }else if (x < scrollView.contentOffset.x){
        [self panToleft:YES Index:self.index ];
    }
    [self.imgTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}

#pragma mark - 向左滑动,向右滑动结束切换
-(void)panToleft:(BOOL)left Index:(NSInteger)index{
    if (!left) {
        self.index = (index - 1 + self.imgNameArray.count) % self.imgNameArray.count;
    }else{
        self.index = (index + 1) % self.imgNameArray.count;
    
    } 
    //切换图片
    [self layoutImages];
    //回位操作
    [self.imgScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];

}

-(void)layoutImages{
    for (int i = 0; i < 3; i++) {
        
        [self.imgNameArray[i] sd_setImageWithURL:[NSURL URLWithString:self.imgArray[(self.index - 1 + i + self.imgNameArray.count) % self.imgNameArray.count]]];
    }

}
-(void)setIndex:(NSInteger)index
{
    if (_index != index) {
        _index = index;
        self.imgPageControl.currentPage = index;
    }

}
//添加block
-(void)addTapBlock:(void (^)(NSInteger))block
{
    self.tapBlock = block;
}


@end
