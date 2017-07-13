//
//  NTGVideoCell.m
//  养老中国
//
//  Created by nbc on 16/7/29.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGVideoCell.h"
#import <UIImageView+WebCache.h>
#import "LSPlayerView.h"

@interface NTGVideoCell ()


@end
@implementation NTGVideoCell

-(void)layoutSubviews
{

}
-(void)setArticle:(NTGArticle *)article{
    _article = article;
    [self.mediaImgV sd_setImageWithURL:[NSURL URLWithString:self.article.mediaImage]];
    self.titleLabel.text = _article.title;
    self.disPlayTimeLabel.text = self.article.displayTime;
    self.resourceLabel.text = self.article.articleSourceName;
    
    
}
- (IBAction)playClick:(id)sender {
    LSPlayerView* playerView = [LSPlayerView playerView];
    playerView.index=self.index;
    playerView.currentFrame=self.mediaImgV.frame;
    
    //必须先设置tempSuperView在设置videoURL
    playerView.tempSuperView=self.superview.superview;
    playerView.videoURL=self.article.media;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
