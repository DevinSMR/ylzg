/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <UIKit/UIKit.h>
#import "NTGArticleComment.h"
@interface NTGCommentCell : UITableViewCell
@property (nonatomic,strong) NTGArticleComment *comment;
//点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
/**评论的点赞数量*/
@property (weak, nonatomic) IBOutlet UILabel *priseNum;

//个人账号ID,如果和评论的ID相同则表明是自己已经点过赞的，设置为选中状态
@property (nonatomic,assign) BOOL isPraise;

+ (instancetype)theSectionHeaderCell;
+ (instancetype)theCommentCellWithTableView:(UITableView *)tableView;
@end
