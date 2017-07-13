//
//  NTGFavoiteEditCell.h
//  养老中国
//
//  Created by nbc on 16/8/25.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTGArticle.h"
@interface NTGFavoiteEditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,strong) NTGArticle *article;
@end
