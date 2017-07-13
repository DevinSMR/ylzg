/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

/**
 * tool - 手势操作
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGGestureRecognizer
#define kMinTickleSpacing 20.0
#define kMaxTickleCount 3

- (void)reset {
    _tickleCount = 0;
    _currentTickleStart = CGPointZero;
    _lastDirection = DirectionUnknown;
    
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _currentTickleStart = [touch locationInView:self.view]; //设置当前挠痒开始坐标位置
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //『当前挠痒开始坐标位置』和『移动后坐标位置』进行 X 轴值比较，得到是向左还是向右移动
    UITouch *touch = [touches anyObject];
    CGPoint tickleEnd = [touch locationInView:self.view];
    CGFloat tickleSpacing = tickleEnd.x - _currentTickleStart.x;
    Direction currentDirection = tickleSpacing < 0 ? DirectionLeft : DirectionRight;
    
    //移动的 X 轴间距值是否符合要求，足够大
    if (ABS(tickleSpacing) >= kMinTickleSpacing) {
        //判断是否有三次不同方向的动作，如果有则手势结束，将执行回调方法
        if (_lastDirection == DirectionUnknown ||
            (_lastDirection == DirectionLeft && currentDirection == DirectionRight) ||
            (_lastDirection == DirectionRight && currentDirection == DirectionLeft)) {
            _tickleCount++;
            _currentTickleStart = tickleEnd;
            _lastDirection = currentDirection;
            
            if (_tickleCount >= kMaxTickleCount && self.state == UIGestureRecognizerStatePossible) {
                self.state = UIGestureRecognizerStateEnded;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self reset];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self reset];
}

//#pragma mark - 处理手势操作
//36 /**
//    37  *  处理拖动手势
//    38  *
//    39  *  @param recognizer 拖动手势识别器对象实例
//    40  */
//41 - (void)handlePan:(UIPanGestureRecognizer *)recognizer {
//    42     //视图前置操作
//    43     [recognizer.view.superview bringSubviewToFront:recognizer.view];
//    44
//    45     CGPoint center = recognizer.view.center;
//    46     CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
//    47     CGPoint translation = [recognizer translationInView:self.view];
//    48     //NSLog(@"%@", NSStringFromCGPoint(translation));
//    49     recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
//    50     [recognizer setTranslation:CGPointZero inView:self.view];
//    51
//    52     if (recognizer.state == UIGestureRecognizerStateEnded) {
//        53         //计算速度向量的长度，当他小于200时，滑行会很短
//        54         CGPoint velocity = [recognizer velocityInView:self.view];
//        55         CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
//        56         CGFloat slideMult = magnitude / 200;
//        57         //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
//        58
//        59         //基于速度和速度因素计算一个终点
//        60         float slideFactor = 0.1 * slideMult;
//        61         CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
//                                                    62                                          center.y + (velocity.y * slideFactor));
//        63         //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
//        64         finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
//                                      65                            self.view.bounds.size.width - cornerRadius);
//        66         finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
//                                      67                            self.view.bounds.size.height - cornerRadius);
//        68
//        69         //使用 UIView 动画使 view 滑行到终点
//        70         [UIView animateWithDuration:slideFactor*2
//                    71                               delay:0
//                    72                             options:UIViewAnimationOptionCurveEaseOut
//                    73                          animations:^{
//                        74                              recognizer.view.center = finalPoint;
//                        75                          }
//                    76                          completion:nil];
//        77     }
//    78 }
//79
//80 /**
//    81  *  处理捏合手势
//    82  *
//    83  *  @param recognizer 捏合手势识别器对象实例
//    84  */
//85 - (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
//    86     CGFloat scale = recognizer.scale;
//    87     recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, scale, scale); //在已缩放大小基础下进行累加变化；区别于：使用 CGAffineTransformMakeScale 方法就是在原大小基础下进行变化
//    88     recognizer.scale = 1.0;
//    89 }
//90
//91 /**
//    92  *  处理旋转手势
//    93  *
//    94  *  @param recognizer 旋转手势识别器对象实例
//    95  */
//96 - (void)handleRotation:(UIRotationGestureRecognizer *)recognizer {
//    97     recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
//    98     recognizer.rotation = 0.0;
//    99 }
//100
//101 /**
//     102  *  处理点按手势
//     103  *
//     104  *  @param recognizer 点按手势识别器对象实例
//     105  */
//106 - (void)handleTap:(UITapGestureRecognizer *)recognizer {
//    107     UIView *view = recognizer.view;
//    108     view.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    109     view.transform = CGAffineTransformMakeRotation(0.0);
//    110     view.alpha = 1.0;
//    111 }
//112
//113 /**
//     114  *  处理长按手势
//     115  *
//     116  *  @param recognizer 点按手势识别器对象实例
//     117  */
//118 - (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
//    119     //长按的时候，设置不透明度为0.7
//    120     recognizer.view.alpha = 0.7;
//    121 }
//122
//123 /**
//     124  *  处理轻扫手势
//     125  *
//     126  *  @param recognizer 轻扫手势识别器对象实例
//     127  */
//128 - (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
//    129     //代码块方式封装操作方法
//    130     void (^positionOperation)() = ^() {
//        131         CGPoint newPoint = recognizer.view.center;
//        132         newPoint.y -= 20.0;
//        133         _imgV.center = newPoint;
//        134
//        135         newPoint.y += 40.0;
//        136         _imgV2.center = newPoint;
//        137     };
//    138
//    139     //根据轻扫方向，进行不同控制
//    140     switch (recognizer.direction) {
//            141         case UISwipeGestureRecognizerDirectionRight: {
//                142             positionOperation();
//                143             break;
//                144         }
//            145         case UISwipeGestureRecognizerDirectionLeft: {
//                146             positionOperation();
//                147             break;
//                148         }
//            149         case UISwipeGestureRecognizerDirectionUp: {
//                150             break;
//                151         }
//            152         case UISwipeGestureRecognizerDirectionDown: {
//                153             break;
//                154         }
//        155     }
//    156 }
//157
//158 /**
//     159  *  处理自定义手势
//     160  *
//     161  *  @param recognizer 自定义手势识别器对象实例
//     162  */
//163 - (void)handleCustomGestureRecognizer:(KMGestureRecognizer *)recognizer {
//    164     //代码块方式封装操作方法
//    165     void (^positionOperation)() = ^() {
//        166         CGPoint newPoint = recognizer.view.center;
//        167         newPoint.x -= 20.0;
//        168         _imgV.center = newPoint;
//        169
//        170         newPoint.x += 40.0;
//        171         _imgV2.center = newPoint;
//        172     };
//    173
//    174     positionOperation();
//    175 }
//176
//177
//178 #pragma mark - 绑定手势操作
//179 /**
//     180  *  绑定拖动手势
//     181  *
//     182  *  @param imgVCustom 绑定到图片视图对象实例
//     183  */
//184 - (void)bindPan:(UIImageView *)imgVCustom {
//    185     UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                  186                                                                                  action:@selector(handlePan:)];
//    187     [imgVCustom addGestureRecognizer:recognizer];
//    188 }
//189
//190 /**
//     191  *  绑定捏合手势
//     192  *
//     193  *  @param imgVCustom 绑定到图片视图对象实例
//     194  */
//195 - (void)bindPinch:(UIImageView *)imgVCustom {
//    196     UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
//                                                    197                                                                                      action:@selector(handlePinch:)];
//    198     [imgVCustom addGestureRecognizer:recognizer];
//    199     //[recognizer requireGestureRecognizerToFail:imgVCustom.gestureRecognizers.firstObject];
//    200 }
//201
//202 /**
//     203  *  绑定旋转手势
//     204  *
//     205  *  @param imgVCustom 绑定到图片视图对象实例
//     206  */
//207 - (void)bindRotation:(UIImageView *)imgVCustom {
//    208     UIRotationGestureRecognizer *recognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
//                                                       209                                                                                            action:@selector(handleRotation:)];
//    210     [imgVCustom addGestureRecognizer:recognizer];
//    211 }
//212
//213 /**
//     214  *  绑定点按手势
//     215  *
//     216  *  @param imgVCustom 绑定到图片视图对象实例
//     217  */
//218 - (void)bindTap:(UIImageView *)imgVCustom {
//    219     UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                  220                                                                                  action:@selector(handleTap:)];
//    221     //使用一根手指双击时，才触发点按手势识别器
//    222     recognizer.numberOfTapsRequired = 2;
//    223     recognizer.numberOfTouchesRequired = 1;
//    224     [imgVCustom addGestureRecognizer:recognizer];
//    225 }
//226
//227 /**
//     228  *  绑定长按手势
//     229  *
//     230  *  @param imgVCustom 绑定到图片视图对象实例
//     231  */
//232 - (void)bindLongPress:(UIImageView *)imgVCustom {
//    233     UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    234     recognizer.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
//    235     [imgVCustom addGestureRecognizer:recognizer];
//    236 }
//237
//238 /**
//     239  *  绑定轻扫手势；支持四个方向的轻扫，但是不同的方向要分别定义轻扫手势
//     240  */
//241 - (void)bindSwipe {
//    242     //向右轻扫手势
//    243     UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
//                                                    244                                                                                      action:@selector(handleSwipe:)];
//    245     recognizer.direction = UISwipeGestureRecognizerDirectionRight; //设置轻扫方向；默认是 UISwipeGestureRecognizerDirectionRight，即向右轻扫
//    246     [self.view addGestureRecognizer:recognizer];
//    247     [recognizer requireGestureRecognizerToFail:_customGestureRecognizer]; //设置以自定义挠痒手势优先识别
//    248     
//    249     //向左轻扫手势
//    250     recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
//                          251                                                            action:@selector(handleSwipe:)];
//    252     recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    253     [self.view addGestureRecognizer:recognizer];
//    254     [recognizer requireGestureRecognizerToFail:_customGestureRecognizer]; //设置以自定义挠痒手势优先识别
//    255 }
//256 
//257 /**
//     258  *  绑定自定义挠痒手势；判断是否有三次不同方向的动作，如果有则手势结束，将执行回调方法
//     259  */
//260 - (void)bingCustomGestureRecognizer {
//    261     //当 recognizer.state 为 UIGestureRecognizerStateEnded 时，才执行回调方法 handleCustomGestureRecognizer:
//    262     
//    263     //_customGestureRecognizer = [KMGestureRecognizer new];
//    264     _customGestureRecognizer = [[KMGestureRecognizer alloc] initWithTarget:self
//                                        265                                                                     action:@selector(handleCustomGestureRecognizer:)];
//    266     [self.view addGestureRecognizer:_customGestureRecognizer];
//    267 }
@end
