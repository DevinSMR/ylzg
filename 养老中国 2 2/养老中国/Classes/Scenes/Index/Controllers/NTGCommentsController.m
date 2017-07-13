/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGCommentsController.h"
#import "NTGPage.h"
#import "NTGCommentCell.h"
/**
 *  control - 所有评论
 */
@interface NTGCommentsController ()<UITableViewDelegate,UITableViewDataSource>
//底部椭圆所在视图
@property (weak, nonatomic) IBOutlet UIView *commentView;
//被隐藏的评论视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//顶部黑色半透明视图
@property (weak, nonatomic) IBOutlet UIView *topView;
//评论内容
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (nonatomic,strong) NSMutableArray *commentArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableDictionary *reqParam;

//是否已经为评论点过赞
@property (nonatomic,assign) BOOL isPraiseComment;

@end

@implementation NTGCommentsController
- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _commentView.layer.borderColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1].CGColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.commentArray = [NSMutableArray array];
    [self pageInitData:NTGPulRefreshInit];
    // Do any additional setup after loading the view.
}
-(void)setCommentArray:(NSMutableArray *)commentArray{

    _commentArray = commentArray;
    [self.tableView reloadData];
}
-(void) clearDataArray {
    _commentArray = [NSMutableArray array];
    [self.tableView reloadData];
}

- (void)addDataArray:(NSArray *)dataArray {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_commentArray];
    [temp addObjectsFromArray:dataArray];
    _commentArray= temp;
    [self.tableView reloadData];
}

- (void) pageInitData :(NTGPullRefresh)action {
    if (action == NTGPulRefreshInit || action == NTGPulRefreshDown) {
        // [self.reqParam setObject:@"1" forKey:@"pageNumber"];
        self.reqParam = [NSMutableDictionary new];
        [self.reqParam setValue:self.articleId forKey:@"id"];
        [self.reqParam setValue:@"1" forKey:@"pageNumber"];
        [self.reqParam setValue:@"20" forKey:@"pageSize"];
    }
    
    [self initData:action];
}

/** 更新数据 */
- (void) initData :(NTGPullRefresh)action{
    //请求最新文章数据
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGPage *page){
        
        NSArray *article = page.content;
        if (article.count == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            self.tableView.tableFooterView = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            label.text = @"已经到底部！";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
        }else{
            [self updateTableView:article action:action state:YES];
        }
    };
    // [NTGSendRequest getListLastest:self.reqParam success:result];
    //测试接口
    //    [NTGSendRequest getlistCulture:nil success:result];
    //    [NTGSendRequest getListNews:nil success:result];
    //    [NTGSendRequest getListTechnology:nil success:result];
    //[NTGSendRequest getListPictures:self.reqParam success:result];
    [NTGSendRequest getArticleComment:self.reqParam success:result];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [NTGCommentCell theSectionHeaderCell ];

}
- (void) updateTableView:(NSArray *)dataArray action:(NTGPullRefresh)action state:(BOOL) state {
    if (action == NTGPulRefreshDown || action == NTGPulRefreshInit) {//表示是下拉刷新、初始化加载
        if (state) {
            [self clearDataArray];
        }
        
        if (action == NTGPulRefreshDown) {
            [self.tableView.mj_header endRefreshing];
        }
        
    }
    else{//上拉加载
        if (dataArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }
    if (state) {
        NSString *pageNumber = [self.reqParam valueForKey:@"pageNumber"];
        pageNumber = [NSString stringWithFormat:@"%d",([pageNumber intValue] + 1) ];
        [self.reqParam setValue:pageNumber forKey:@"pageNumber"];
        [self  addDataArray:dataArray];
    }
}

//这个方法是为了不让分区的头部视图悬停
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 51;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTGCommentCell *cell = [NTGCommentCell theCommentCellWithTableView:tableView];
    cell.comment = self.commentArray[indexPath.row];
    //判断是否已经为评论点过赞
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    long ID = [userID longLongValue];
    _isPraiseComment = NO;//每次获取是否已点赞是先把它置为NO,否则直接调用上一个cell的结果
    for (NTGPraiseMembers *praiseMember in cell.comment.praiseMembers) {
        if (praiseMember.id == ID) {
            _isPraiseComment = YES;
        }
    }
    cell.isPraise = _isPraiseComment;
    [cell.praiseBtn addTarget:self action:@selector(commentPraiseAction:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 111;


}

//为评论点赞
-(void)commentPraiseAction:(UIButton *)button{
    NTGCommentCell *cell = (NTGCommentCell *)button.superview.superview;
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(id object){
        NSDictionary *dict = (NSDictionary *)object;
        NSString *str = [dict[@"isPraise"] stringValue];
        if ([str isEqualToString:@"1"]) {
            cell.praiseBtn.selected = YES;
        }else{
            cell.praiseBtn.selected = NO;
        }
        NSString *num = [dict[@"praiseNum"] stringValue];
        cell.priseNum.text = num;
    };
    [NTGSendRequest setCommentPraise:@{@"id":[NSString stringWithFormat:@"%ld", (long)cell.comment.id]} success:result];
}

//显示评论页面
- (IBAction)showCommentView:(id)sender {
    self.bottomView.hidden = NO;
    self.topView.hidden = NO;
    [self.commentTextView becomeFirstResponder];
}
//取消评论
- (IBAction)cancleCommentAction:(id)sender {
    self.bottomView.hidden = YES;
    self.topView.hidden = YES;
    [self.commentTextView resignFirstResponder];
}
//发表评论
- (IBAction)publishCommentAction:(id)sender {
    
    [self.commentTextView resignFirstResponder];
    if (self.commentTextView.text.length > 0) {
        NSDictionary *dict= @{@"id":self.articleId,@"content":self.commentTextView.text};
        NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
        result.onSuccess = ^(id responseObject) {
            [NTGMBProgressHUD alertView:@"评论成功" view:self.view];
            self.bottomView.hidden = YES;
            self.topView.hidden = YES;
            self.commentTextView.text = nil;
            
            [self.reqParam setValue:self.articleId forKey:@"id"];
            [self.reqParam setValue:@"1" forKey:@"pageNumber"];
            [self.reqParam setValue:@"20" forKey:@"pageSize"];
            NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
            result.onSuccess = ^(NTGPage *page){
                _commentArray = [NSMutableArray arrayWithArray:page.content] ;
                [self.tableView reloadData];
            
            };
            [NTGSendRequest getArticleComment:_reqParam success:result];
            
            
        };
        [NTGSendRequest publishComment:dict success:result];
        
    }else{
        
        [NTGMBProgressHUD alertView:@"内容不能为空" view:self.view];
        
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
