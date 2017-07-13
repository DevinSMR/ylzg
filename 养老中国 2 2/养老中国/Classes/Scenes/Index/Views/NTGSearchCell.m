
//
//  NTGSearchCell.m
//  养老中国
//
//  Created by nbc on 16/8/24.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGSearchCell.h"
@interface NTGSearchCell ()
@property (weak, nonatomic) IBOutlet UILabel *hotSearch;

@end
@implementation NTGSearchCell
//-(void)layoutSubviews{
//    _hotSearch.text = _model;
//
//
//}

CGFloat heightForCell = 35;
-(void)setModel:(NSString *)model{
    _model = model;
    _hotSearch.text = _model;
    _hotSearch.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];



}
- (CGSize)sizeForCell {
    //宽度加 heightForCell 为了两边圆角。
    return CGSizeMake((kScreenWidth - 32) / 2.0, heightForCell);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
