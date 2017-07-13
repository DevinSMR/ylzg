/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGGeneralCell.h"
#import <UIImageView+WebCache.h>
/**
 * view - 最新，文化，科技，新闻通用Cell
 *
 * @author nbcyl Team
 * @version 3.0
 */

@interface NTGGeneralCell ()
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;

@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;

@end
@implementation NTGGeneralCell
-(void)layoutSubviews
{
    if ([self.article.tagType isEqualToString:@"media"]) {
        [self.newsImage sd_setImageWithURL:[NSURL URLWithString:self.article.mediaImage] placeholderImage:[UIImage imageNamed:@"index_backImg"]];
    }else{
        [self.newsImage sd_setImageWithURL:[NSURL URLWithString:self.article.image] placeholderImage:[UIImage imageNamed:@"index_backImg"]];
    
    }
    //设置行间距
     NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.article.title];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.article.title length])];
    [_titleLabel setAttributedText:attributedString];
  // self.titleLabel.text = self.article.title;
    self.creatTimeLabel.text = self.article.displayTime;
    self.sourceLabel.text = self.article.articleSourceName;
    if ([self.article.tagType isEqualToString:@"image"]) {
        self.typeImgV.image = [UIImage imageNamed:@"picture"];
    }else if([self.article.tagType isEqualToString:@"media"]){
        self.typeImgV.image = [UIImage imageNamed:@"video"];
    
    }else{
        self.typeImgV.image = nil;
    }
    self.selectBtn.selected = self.article.tag;

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
