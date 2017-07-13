/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

//StatusBar显示跑马灯封装类
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

/**
 * tool - 跑马灯
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface AMN_StatusViewControl : UIView
{
    //接收主页面传来的显示数据
    NSMutableArray *_msgArray;
    
    AppDelegate *_delegate;
    
    UIImage *_bgImage;
    
    //用于获取运行时间，如果为小于单次时间则只跑一次,如果为0则永久运行
    int _runTime;
    
    //用于获得单条运行时间，完整单条运行时间应为单条运行时间＋间隔时间
    int _eachTime;
    
    //用于获得间隔时间
    int _intervalTime;
    
    //用于获得StatusBar宽度
    float _statusWidth;
    
    //总运行次数，根据运行时间除以完整单条运行时间取得
    int _runCount;
    
    //已运行次数，单条运行的次数
    int _runNum;
    
    //纪录显示数据的编号
    int _msgNum;
}

@property (nonatomic, retain) NSMutableArray *msgArray;
@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, assign) int runTime;
@property (nonatomic, assign) int eachTime;
@property (nonatomic, assign) int intervalTime;

- (id)init;
- (void)showStatusMessage;
- (void)runMsg;
- (void)stopAnimation;

@end
