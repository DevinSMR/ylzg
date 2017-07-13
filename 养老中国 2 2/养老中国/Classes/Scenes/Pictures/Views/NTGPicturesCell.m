/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */


#import "NTGPicturesCell.h"
#import <UIImageView+WebCache.h>
/**
 *  view - 图片频道cell
 */

@interface NTGPicturesCell ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyWordLabel;

@end
@implementation NTGPicturesCell
-(void)layoutSubviews
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.article.image] placeholderImage:[UIImage imageNamed:@"index_backImg"]];
    UIDevice *device = [UIDevice currentDevice];
    if ([device.model isEqualToString:@"iPhone"]) {
//        if (self.article.title.length > 15) {
//           self.article.title = [self.article.title substringToIndex:15];
//
//        }
        self.titleLabel.text = self.article.title;
    }else{
        self.titleLabel.text = self.article.title;
    }
    //self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.displayTimeLabel.text = self.article.displayTime;
    self.keyWordLabel.text = self.article.articleTag;
    self.resourceLabel.text = self.article.articleSourceName;
    self.totalLabel.text = [NSString stringWithFormat:@"%ld",self.article.articleImage.count];


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
