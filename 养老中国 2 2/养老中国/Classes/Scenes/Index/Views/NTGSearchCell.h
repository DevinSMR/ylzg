//
//  NTGSearchCell.h
//  养老中国
//
//  Created by nbc on 16/8/24.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTGSearchCell : UICollectionViewCell
@property (nonatomic,strong) NSString *model;
- (CGSize)sizeForCell;
//+(instancetype)creatInsectionHeaderView;
@end
