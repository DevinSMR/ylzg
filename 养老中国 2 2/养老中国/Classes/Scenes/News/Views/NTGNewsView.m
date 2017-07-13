/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGNewsView.h"
/**
 * view - 新闻页
 *
 * @author nbcyl Team
 * @version 3.0
 */
@interface NTGNewsView ()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation NTGNewsView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.newsTableView = [[UITableView alloc] initWithFrame:frame];
        self.newsTableView.dataSource = self;
        self.newsTableView.delegate = self;
        [self addSubview:self.newsTableView];
        
        
    }
    return self;
}
//初始化页面

#pragma mark - 代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//
//}
@end
