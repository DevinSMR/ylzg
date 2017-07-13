/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGCommentCell.h"

/**
 * view - 评论cell
 *
 * @author nbcyl Team
 * @version 3.0
 */
@interface NTGCommentCell ()
@property (weak, nonatomic) IBOutlet UILabel *petName;
@property (weak, nonatomic) IBOutlet UIImageView *iconImV;
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
@implementation NTGCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)theSectionHeaderCell{
    
    return [[NSBundle mainBundle]loadNibNamed:@"NTGCommentCell" owner:nil options:nil][1];
    
}
+(instancetype)theCommentCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"commentCell";
    NTGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"NTGCommentCell" owner:nil options:nil][0];
    }
    return cell;
}



-(void)layoutSubviews{
    self.petName.text = self.comment.petName;
    //[self.iconImV sd_setImageWithURL:[NSURL URLWithString:self.comment.picture] placehoderImage:[UIImage imageNamed:@"mine"]];
    self.iconImV.layer.cornerRadius  = 14;
    self.iconImV.layer.masksToBounds = YES;
    [self.iconImV sd_setImageWithURL:[NSURL URLWithString:self.comment.picture] placeholderImage:[UIImage imageNamed:@"mine"]];
    self.content.text = self.comment.content;
    self.createDate.text = [self dateFromString:self.comment.createDate];
    self.priseNum.text = self.comment.praiseNum;
    self.praiseBtn.selected = _isPraise ? YES : NO;
}
//-(void)setComment:(NTGArticleComment *)comment{
//        _comment = comment;
//        self.petName.text = comment.petName;
//        //[self.iconImV sd_setImageWithURL:[NSURL URLWithString:self.comment.picture] placehoderImage:[UIImage imageNamed:@"mine"]];
//        self.iconImV.layer.cornerRadius  = 14;
//        self.iconImV.layer.masksToBounds = YES;
//        [self.iconImV sd_setImageWithURL:[NSURL URLWithString:comment.picture] placeholderImage:[UIImage imageNamed:@"mine"]];
//        self.content.text = comment.content;
//        self.createDate.text = [self dateFromString:comment.createDate];
//        self.priseNum.text = comment.praiseNum;
//        self.praiseBtn.selected = _isPraise ? YES : NO;
//}
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
