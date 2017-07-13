//
//  NTGMyCommentCell.h
//  养老中国
//
//  Created by nbc on 16/8/31.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTGMyComment.h"
@interface NTGMyCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong) NTGMyComment *myComment;
@property (nonatomic,assign)void(^deleteComment)(long ID);
@end
