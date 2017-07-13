
//
//  NTGFavoiteEditCell.m
//  养老中国
//
//  Created by nbc on 16/8/25.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGFavoiteEditCell.h"
@interface NTGFavoiteEditCell ()
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@end
@implementation NTGFavoiteEditCell
-(void)layoutSubviews
{
    
    [self.newsImage sd_setImageWithURL:[NSURL URLWithString:self.article.image] placeholderImage:[UIImage imageNamed:@"index_backImg"]];
    //设置行间距
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.article.title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.article.title length])];
    [_titleLabel setAttributedText:attributedString];
    // self.titleLabel.text = self.article.title;
    self.creatTimeLabel.text = self.article.displayTime;
    self.sourceLabel.text = self.article.articleSourceName;
    self.selectBtn.selected = self.article.tag;
    if ([self.article.tagType isEqualToString:@"image"]) {
        self.typeImgV.image = [UIImage imageNamed:@"picture"];
    }else if([self.article.tagType isEqualToString:@"media"]){
        self.typeImgV.image = [UIImage imageNamed:@"video"];
        
    }else{
        self.typeImgV.image = nil;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
