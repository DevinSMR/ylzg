//
//  VideoCell.m
//  WMVideoPlayer
//
//  Created by zhengwenming on 16/1/17.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "VideoCell.h"
#import "VideoModel.h"
@implementation VideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(VideoModel *)model{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   // self.titleLabel.text = model.title;
    UIDevice *device = [UIDevice currentDevice];
    if ([device.model isEqualToString:@"iPhone"]) {
        if (model.title.length > 15) {
            model.title = [model.title substringToIndex:15];
            
        }
        self.titleLabel.text = model.title;
    }else{
        self.titleLabel.text = model.title;
    }

    self.sourceLabel.text = model.articleSourceName;
    self.displayTimeLabel.text = model.displayTime;
    [self.backgroundIV sd_setImageWithURL:[NSURL URLWithString:model.mediaImage] placeholderImage:[UIImage imageNamed:@"index_backImg"]];

}
@end
