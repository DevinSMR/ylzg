/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "AMN_StatusViewControl.h"
#define FONTSIZE    13

/**
 * tool - 跑马灯
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation AMN_StatusViewControl

@synthesize msgArray = _msgArray;
@synthesize bgImage = _bgImage;
@synthesize runTime = _runTime;
@synthesize eachTime = _eachTime;
@synthesize intervalTime = _intervalTime;

#pragma mark - view lifecycle

//对跑马灯进行初始设置
- (id)init
{
    self = [super init];
    if (self) {
        _msgNum = 0;
        _runNum = 0;
        _runCount = 0;
        
        //获得程序代理，以便对设备StatusBar进行控制
        _delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //获得设备StatusBar权限
        [_delegate.window setWindowLevel:UIWindowLevelAlert];
        
        //设置跑马灯大小位置及背景色
        _statusWidth = _delegate.window.bounds.size.width;
        self.frame = CGRectMake(0, 0, _statusWidth, 20);
        self.backgroundColor = [UIColor clearColor];
        
        //创建跑马灯背景图片
        UIImageView *iBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _statusWidth, 20)];
        iBgImage.backgroundColor = [UIColor clearColor];
        iBgImage.tag = 50;
        [self addSubview:iBgImage];
//        [iBgImage release];
        
        //创建搭载跑马灯的视图
        UIView *iContentView = [[UIView alloc] initWithFrame:CGRectMake(_statusWidth, 0, _statusWidth, 20)];
        iContentView.backgroundColor = [UIColor clearColor];
        iContentView.tag = 100;
        [self addSubview:iContentView];
//        [iContentView release];
        
        //创建显示跑马灯内容的标签
        UILabel* iStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_statusWidth, 0, _statusWidth, 20)];
        iStatusLabel.tag = 10;
        [iStatusLabel setBackgroundColor:[UIColor clearColor]];
        [iStatusLabel setTextColor:[UIColor whiteColor]];
        [iStatusLabel setTextAlignment:NSTextAlignmentCenter];
        [iStatusLabel setFont:[UIFont systemFontOfSize:FONTSIZE]];
        [iContentView addSubview:iStatusLabel];
        
        //在主窗口加载视图
        [_delegate.window addSubview:self];
    }
    return self;
}

//- (void)dealloc
//{
//    [_msgArray release];
//    [_delegate release];
//    [_bgImage release];
//    
//    [super dealloc];
//}

#pragma mrak Class methods

//开始显示跑马灯
- (void)showStatusMessage
{
    //如果总运行时间为0,设置总运行次数为0,将永久运行；否则根据总运行时间同单条运行时间加间隔时间的关系取得总运行次数
    if (self.runTime == 0) {
        _runCount = 0;
    } else {
        //如果总运行时间小于单条运行时间加间隔时间，总运行次数为1；
        if (self.runTime - (self.eachTime + self.intervalTime) <= 0) {
            _runCount = 1;
        } else {
            //如果总运行时间模单条运行时间加间隔时间为0,总运行次数是总运行时间整除单条运行时间加间隔时间；否则还需要加1
            if (self.runTime % (self.eachTime + self.intervalTime) == 0) {
                _runCount = self.runTime / (self.eachTime + self.intervalTime);
            } else {
                _runCount = self.runTime / (self.eachTime + self.intervalTime) + 1;
            }
        }
    }
    
    //如果显示数据有内容，根据显示内容的长度设置显示标签的宽度，并启动跑马灯动画
    if ([self.msgArray count] > 0) {
        UIView *iContentView = (UIView *)[self viewWithTag:100];
        
        UILabel *iStatusLabel = (UILabel *)[iContentView viewWithTag:10];
        iStatusLabel.text = [self.msgArray objectAtIndex:0];
        
        CGRect iRect = iStatusLabel.frame;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:FONTSIZE]};
        CGSize iSize = [iStatusLabel.text sizeWithAttributes:attributes];
//        CGSize iSize = [iStatusLabel.text sizeWithFont:[UIFont systemFontOfSize:FONTSIZE]];
        iRect.size.width = iSize.width;
        iStatusLabel.frame = CGRectMake(0, 0, iRect.size.width, iRect.size.height);
        
        UIImageView *iBgImage = (UIImageView *)[self viewWithTag:50];
        iBgImage.image = self.bgImage;
        
        [self runMsg];
    }
}

//运行跑马灯动画
- (void)runMsg
{
    UIImageView *iBgImage = (UIImageView *)[self viewWithTag:50];
    iBgImage.hidden = NO;
    
    UIView *iContentView = (UIView *)[self viewWithTag:100];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.eachTime];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopAnimation)];
    iContentView.frame = CGRectMake(-_statusWidth, 0, _statusWidth, 20);
    [UIView commitAnimations];
}

//停止动画并隐藏，同时准备下一次显示数据
- (void)stopAnimation
{
    UIImageView *iBgImage = (UIImageView *)[self viewWithTag:50];
    iBgImage.hidden = YES;
    
    UIView *iContentView = (UIView *)[self viewWithTag:100];
    iContentView.frame = CGRectMake(_statusWidth, 0, _statusWidth, 20);
    
    //已运行次数与显示数据编号加1
    _runNum++;
    _msgNum++;
    
    //如果不是永久运行并且已运行次数与总次数相同，就将跑马灯停止；否则继续运行
    if (_runCount != 0 && _runNum == _runCount) {
        [_delegate.window setWindowLevel:UIWindowLevelNormal];
    } else {
        //如果数据编号与数据数量相同，则数据编号重新设置为第一条
        if (_msgNum == [self.msgArray count]) {
            _msgNum = 0;
        }
        
        //重新获得数据，并根据数据长度设置标签宽度
        UILabel *iStatusLabel = (UILabel *)[iContentView viewWithTag:10];
        iStatusLabel.text = [self.msgArray objectAtIndex:0];
        
        CGRect iRect = iStatusLabel.frame;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:FONTSIZE]};
        CGSize iSize = [iStatusLabel.text sizeWithAttributes:attributes];
        iRect.size.width = iSize.width;
        iStatusLabel.frame = CGRectMake(0, 0, iRect.size.width, iRect.size.height);
        
        //根据间隔时间等待下一条显示
        [self performSelector:@selector(runMsg) withObject:nil afterDelay:self.intervalTime];
    }
}

@end
