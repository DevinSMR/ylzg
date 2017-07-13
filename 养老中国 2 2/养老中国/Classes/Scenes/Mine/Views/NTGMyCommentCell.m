
//
//  NTGMyCommentCell.m
//  养老中国
//
//  Created by nbc on 16/8/31.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGMyCommentCell.h"
@interface NTGMyCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@end
@implementation NTGMyCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMyComment:(NTGMyComment *)myComment{
    
    //必须设置label的最大宽度，不然系统无法计算label的最大高度（方法2代码）
    CGFloat preferredWidth = [UIScreen mainScreen].bounds.size.width ;
    self.titleLabel.preferredMaxLayoutWidth = preferredWidth -100;
    self.createTimeLbl.preferredMaxLayoutWidth = preferredWidth - 100;
    self.contentLbl.preferredMaxLayoutWidth = preferredWidth - 64;
    _titleLabel.text = myComment.memberArticle[@"title"];
    _createTimeLbl.text = [self dateFromString:myComment.createDate];
    _contentLbl.text = myComment.content;
    //[_deleteBtn addTarget:self action:@selector(deleteCommentAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)deleteCommentAction{

    _deleteComment(_myComment.id);

}
-(NSString *)dateFromString:(NSString *)string{
    NSString*time = string;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    long long t =[time longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:t/1000.0];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    NSString*confromTimespStr = [formatter stringFromDate:d];
    return confromTimespStr;
    
}

@end
