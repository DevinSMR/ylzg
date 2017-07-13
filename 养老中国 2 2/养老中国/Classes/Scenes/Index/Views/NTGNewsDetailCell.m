
//
//  NTGNewsDetailCell.m
//  养老中国
//
//  Created by nbc on 16/8/9.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGNewsDetailCell.h"
@interface NTGNewsDetailCell ()
//文章标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//文章来源
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
//文章发表日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//评论用户头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImV;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *petName;
//点赞数量
@property (weak, nonatomic) IBOutlet UILabel *priseNum;
//评论发表时间
@property (weak, nonatomic) IBOutlet UILabel *createDateLabel;
//评论内容
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;






@end

@implementation NTGNewsDetailCell

//-(void)layoutSubviews{
//    _titleLabel.font = [UIFont boldSystemFontOfSize:21];
//   // _titleLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(21.0)];
//
//}
-(void)setArticle:(NTGArticle *)article
{
    if (_article != article) {
        _article = article;
         _titleLabel.font = [UIFont boldSystemFontOfSize:22];

        _titleLabel.text = article.title;
        _sourceLabel.text = article.articleSourceName;
        NSString *date =  [self dateFromString:self.article.createDate];
        self.dateLabel.text = date;

    }



}
-(void)setComment:(NTGArticleComment *)comment{

    
        _comment = comment;
        [_iconImV sd_setImageWithURL:[NSURL URLWithString:comment.picture] placeholderImage:nil];
        self.petName.text = comment.petName;
        self.createDateLabel.text = [self dateFromString:_comment.createDate];
        self.commentLabel.text = comment.content;
    
   // self.titleLabel.text = comment.petName;
   
   

}

//-(void)layoutSubviews{
//
//    [_iconImV sd_setImageWithURL:[NSURL URLWithString:_comment.picture] placeholderImage:nil];
//    self.petName.text = _comment.petName;
//    self.createDateLabel.text = [self dateFromString:_comment.createDate];
//    self.commentLabel.text = _comment.content;
//
//
//
//
//}
-(NSString *)dateFromString:(NSString *)string{
    NSString*time = string;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    long long t =[time longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:t/1000.0];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString*confromTimespStr = [formatter stringFromDate:d];
    return confromTimespStr;
    
}
+(instancetype)theTitleCell

{
    return [[NSBundle mainBundle]loadNibNamed:@"NTGNewsDetailCell" owner:nil options:nil][0];
    
}

+ (instancetype)theShareCell{
    return [[NSBundle mainBundle]loadNibNamed:@"NTGNewsDetailCell" owner:nil options:nil][1];
}
+(instancetype)theSectionHeaderCell{

    return [[NSBundle mainBundle]loadNibNamed:@"NTGNewsDetailCell" owner:nil options:nil][2];

}
+ (instancetype)theCommentHeaderCell{
    return [[NSBundle mainBundle]loadNibNamed:@"NTGNewsDetailCell" owner:nil options:nil][4];
}
+(instancetype)theCommentsCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"commentCell";
    NTGNewsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"NTGNewsDetailCell" owner:nil options:nil][3];
    }
    return cell;
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
