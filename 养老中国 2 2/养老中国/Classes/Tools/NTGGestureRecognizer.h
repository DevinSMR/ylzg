/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <UIKit/UIKit.h>

/**
 * tool - 手势操作
 *
 * @author nbcyl Team
 * @version 3.0
 */

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionUnknown,
    DirectionLeft,
    DirectionRight
};

//typedef NS_ENUM(NSInteger, UIGestureRecognizerState) {
//    UIGestureRecognizerStatePossible,   // 尚未识别是何种手势操作（但可能已经触发了触摸事件），默认状态
//    UIGestureRecognizerStateBegan,      // 手势已经开始，此时已经被识别，但是这个过程中可能发生变化，手势操作尚未完成
//    UIGestureRecognizerStateChanged,    // 手势状态发生转变
//    UIGestureRecognizerStateEnded,      // 手势识别操作完成（此时已经松开手指）
//    UIGestureRecognizerStateCancelled,  // 手势被取消，恢复到默认状态
//    UIGestureRecognizerStateFailed,     // 手势识别失败，恢复到默认状态
//    UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded // 手势识别完成，同UIGestureRecognizerStateEnded
//};

@interface NTGGestureRecognizer : UIGestureRecognizer
@property (assign, nonatomic) NSUInteger tickleCount; //挠痒次数
@property (assign, nonatomic) CGPoint currentTickleStart; //当前挠痒开始坐标位置
 @property (assign, nonatomic) Direction lastDirection; //最后一次挠痒方向
@end
