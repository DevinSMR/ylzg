/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGClassificationScrollView.h"
/**
 * view - 首页头部分类滚动条
 *
 * @author nbcyl Team
 * @version 3.0
 */

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface NTGClassificationScrollView ()
//分类控件
@property (nonatomic,strong) UIScrollView *itemsScrollView;
//为设置btn的选中状态作中间变量
@property (nonatomic,strong) UIButton *tmpBtn;
@end
@implementation NTGClassificationScrollView
+(instancetype)creatClassificationView
{
     NSArray *array = @[@"最新",@"新闻",@"图片",@"文化",@"视频",@"科技"];
    NTGClassificationScrollView *view = [[self alloc] initWithFrame:CGRectMake(10, 64, ScreenW - 20, 40)];
    [view setNavigationViewsWithTitleArray:array];
    return view;
    

}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemBtnArray = [NSMutableArray array];
       self.itemsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 20 , 40)];
        self.itemsScrollView.contentSize = CGSizeMake(ScreenW - 44, 0);
        self.itemsScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.itemsScrollView];
    }
    return self;

}

//设置导航栏
-(void) setNavigationViewsWithTitleArray:(NSArray *) array
{
    CGFloat width = (ScreenW - 20) / 6 ;
    for (int i = 0; i < array.count; i++) {
        [self addButtonWithTitle:array[i] Frame: CGRectMake(width * i, 0, width, 40) Tag:101 + i];
    }
    self.tmpBtn = self.itemBtnArray[0];
    self.tmpBtn.selected = YES;
    self.tmpBtn.titleLabel.font = [UIFont systemFontOfSize:21];
}

//为导航栏添加Button
-(UIButton *) addButtonWithTitle:(NSString *)title Frame:(CGRect)frame Tag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    button.tag = tag;
    //[button addTarget:self action:@selector(didClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.itemsScrollView addSubview:button];
    [self.itemBtnArray addObject:button];
    return button;
}

-(void)buttonSelected:(UIButton*)sender{
    if (_tmpBtn == nil){
        sender.selected = YES;
        sender.titleLabel.font = [UIFont systemFontOfSize:21];
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
        sender.titleLabel.font = [UIFont systemFontOfSize:21];

        
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _tmpBtn.selected = NO;
        sender.selected = YES;
        sender.titleLabel.font = [UIFont systemFontOfSize:21];

        _tmpBtn = sender;
        

    }
    [self.myDelegate didClickBtnAction:sender];
}

@end
