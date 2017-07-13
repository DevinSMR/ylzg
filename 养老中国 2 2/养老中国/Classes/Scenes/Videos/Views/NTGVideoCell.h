//
//  NTGVideoCell.h
//  养老中国
//
//  Created by nbc on 16/7/29.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTGArticle.h"

@interface NTGVideoCell : UITableViewCell
@property (nonatomic,strong) NTGArticle *article;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *disPlayTimeLabel;

@property (nonatomic, assign) NSInteger index;
@end
