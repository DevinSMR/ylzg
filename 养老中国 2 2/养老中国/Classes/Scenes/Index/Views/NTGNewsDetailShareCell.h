//
//  NTGNewsDetailShareCell.h
//  养老中国
//
//  Created by nbc on 16/10/12.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTGNewsDetailShareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *weiboShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiXinShareBtn;

@property (weak, nonatomic) IBOutlet UIButton *pengyouquanShareBtn;
+(instancetype)theShareCellWithTableView:(UITableView *)tableView;
@end
