/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <UIKit/UIKit.h>

/**
 * tool - 图片压缩
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface UIImage (ScreenShot)

/// 获取屏幕截图
///
/// @return 屏幕截图图像
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
