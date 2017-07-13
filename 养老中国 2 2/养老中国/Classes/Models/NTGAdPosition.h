/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <Foundation/Foundation.h>
#import "NTGAd.h"

/**
 * Entity - 广告位
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGAdPosition : NSObject <NSCoding>

/** 广告 */
@property(nonatomic,strong) NSArray *ads;

/** 后台数据更新时间 */
@property(nonatomic,copy) NSString *modifyDate;
@end
