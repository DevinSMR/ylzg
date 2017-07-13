//
//  NTGNewsDetailShareCell.m
//  养老中国
//
//  Created by nbc on 16/10/12.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGNewsDetailShareCell.h"

@implementation NTGNewsDetailShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)theShareCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"cell";
    NTGNewsDetailShareCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"NTGNewsDetailShareCell" owner:nil options:nil][0];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
