//
//  NTGClassificationScrollView.h
//  养老中国
//
//  Created by Devin on 16/6/28.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NTGCLassifictionScorllViewBtnDelegate <NSObject>

-(void)didClickBtnAction:(UIButton *)sender;

@end

@interface NTGClassificationScrollView : UIView
//养老中国logo
@property (nonatomic,strong) UIImageView *logoImgView;
//导航栏上的button
@property (nonatomic,strong) NSMutableArray *itemBtnArray;
@property (nonatomic,assign)id<NTGCLassifictionScorllViewBtnDelegate>myDelegate;
+(instancetype) creatClassificationView;
@end
