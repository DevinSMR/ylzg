//
//  NTGNewsDetailCell.h
//  养老中国
//
//  Created by nbc on 16/8/9.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTGArticle.h"
#import "NTGArticleComment.h"
@interface NTGNewsDetailCell : UITableViewCell
@property (nonatomic,strong) NTGArticle *article;
@property (nonatomic,strong) NTGArticleComment *comment;
//@property (weak, nonatomic) IBOutlet UILabel *sectionHeader;
@property (weak, nonatomic) IBOutlet UIButton *weiboShareBtn;

@property (weak, nonatomic) IBOutlet UIButton *weixinShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *pyquanShareBTn;

+ (instancetype)theShareCell;
+(instancetype)theTitleCell;
+ (instancetype)theSectionHeaderCell;
+ (instancetype)theCommentHeaderCell;
//
//+ (instancetype)theSectionBottomCell;
//
//+ (instancetype)theHotReplyCellWithTableView:(UITableView *)tableView;
//
+ (instancetype)theCommentsCellWithTableView:(UITableView *)tableView;
//
//+ (instancetype)theCloseCell;
//
//+ (instancetype)theKeywordCell;

@end
