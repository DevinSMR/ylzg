/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import <UIKit/UIKit.h>
#import "NTGArticle.h"
@interface NTGGeneralCell : UITableViewCell
@property (nonatomic,strong) NTGArticle *article;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
//