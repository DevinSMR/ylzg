//
//  NTGCommetController.m
//  养老中国
//
//  Created by nbc on 16/8/25.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGCommetController.h"
#import "NTGPage.h"
#import "NTGMyCommentCell.h"
#import "NTGNewsDetailController.h"
#import "NTGArticle.h"
#import "NTGVideosController.h"
#import "NTGPictureDetailController.h"
@interface NTGCommetController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) long commentID;

@property (nonatomic,strong) NSMutableDictionary *reqParam;

@property (nonatomic,retain) MBProgressHUD* hud;

@end

@implementation NTGCommetController
- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //[self initData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //请求最新文章数据
   // NSDictionary *dict = @{}
    
    [self setupUI];
    [self pageInitData:NTGPulRefreshInit];
}
-(void)initData{
    self.reqParam = [NSMutableDictionary new];
    [self.reqParam setValue:@"1" forKey:@"pageNumber"];
    _dataArray = [NSMutableArray new];
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGPage *page){
        
        //        NSArray *article = page.content;
        //        if (article.count == 0) {
        //            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        //            self.tableView.tableFooterView = view;
        //            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        //            label.text = @"已到加载全部了~";
        //            label.textAlignment = NSTextAlignmentCenter;
        //            [view addSubview:label];
        //        }else{
        //            [self updateTableView:article action:action state:YES];
        //        }
        //        [self.tableView reloadData];
        _dataArray = [NSMutableArray arrayWithArray:page.content];
        if (_dataArray.count == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            self.tableView.tableFooterView = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            label.text = @"还没有评论快快去评论吧~";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
        }

        [_tableView reloadData];
        clickCount = 1;

        self.tableView.estimatedRowHeight = 80.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    };
    [NTGSendRequest getlistComment:nil success:result];
}

-(void)setupUI{
    _tableView.frame = self.view.frame;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"NTGMyCommentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshUp];
        
    }];
    
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshDown];
    }];
    
}
- (void) pageInitData :(NTGPullRefresh)action {
    if (action == NTGPulRefreshInit || action == NTGPulRefreshDown) {
        // [self.reqParam setObject:@"1" forKey:@"pageNumber"];
        self.reqParam = [NSMutableDictionary new];
        [self.reqParam setValue:@"1" forKey:@"pageNumber"];
        NSLog(@"%@",self.reqParam);
    }
    [self initData:action];
}
/** 更新数据 */
- (void) initData :(NTGPullRefresh)action{
    //请求最新文章数据
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGPage *page){
        
        NSArray *article = page.content;
//        if (article.count == 0) {
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//            self.tableView.tableFooterView = view;
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
//            label.text = @"已到加载全部了~";
//            label.textAlignment = NSTextAlignmentCenter;
//            [view addSubview:label];
//        }else{
//            [self updateTableView:article action:action state:YES];
//        }
        [self updateTableView:article action:action state:YES];
    };
    [NTGSendRequest getlistComment:self.reqParam success:result];
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
        NSLog(@"当前的页数为：%@",pageNumber);
        [self.reqParam setValue:pageNumber forKey:@"pageNumber"];
        [self  addDataArray:dataArray];
    }
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)addDataArray:(NSArray *)dataArray {
    if (dataArray.count < 20 && dataArray.count > 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, view.frame.size.width, 40)];
        label.text = @"已到最底部！";
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        self.tableView.tableFooterView = view;
       // self.tableView.userInteractionEnabled = YES;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else if (dataArray.count == 0){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        self.tableView.tableFooterView = view;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        label.text = @"还没有评论快快去评论吧~";
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        self.tableView.userInteractionEnabled = NO;
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_dataArray];
    [temp addObjectsFromArray:dataArray];
    _dataArray= temp;

    [self.tableView reloadData];
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}

-(void) clearDataArray {
    _dataArray = [NSMutableArray array];
    //[self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NTGNewsDetailController *controller = [[UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil] instantiateInitialViewController];
    NTGMyComment *model = _dataArray[indexPath.row];
    NTGArticle *article = [NTGArticle new];
    [article setValuesForKeysWithDictionary:model.memberArticle];
    controller.article = article;
   // [self.navigationController pushViewController:controller animated:YES];
 if([article.tagType isEqualToString:@"image"]){
        UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"PictureDetail" bundle:nil];
        NTGPictureDetailController *pictureVC =  [storyboard2 instantiateInitialViewController];
        pictureVC.article = article;
        if (article.articleImage.count > 0) {
            pictureVC.article = article;
            [self.navigationController pushViewController:pictureVC animated:YES];
            
        }else{
            [NTGMBProgressHUD alertView:@"暂无详情" view:self.view];;
        }
    }else{
        controller.article = article;
        [self.navigationController pushViewController:controller animated:YES];
    }



}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NTGMyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.deleteComment = ^(long ID){
//        [self deleteCommentAction:ID];
//    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    dispatch_queue_t queue = dispatch_queue_create("com.ylzgnet.queue1",DISPATCH_QUEUE_SERIAL );
    dispatch_sync(queue, ^{
        if (indexPath != nil) {
            cell.myComment = _dataArray[indexPath.row];
            [cell.deleteBtn addTarget:self action:@selector(deleteCommentAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
                   });
    return cell;



}

- (void)addHudWithMessage:(NSString*)message
{
    if (!_hud)
    {
        _hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText=message;
    }
    
}
- (void)removeHud
{
    if (_hud) {
        [_hud removeFromSuperview];
        _hud= nil;
    }
}
NSInteger clickCount = 1;
-(void)deleteCommentAction:(UIButton *)button{
    if (clickCount == 1) {
        NTGMyCommentCell *cell = (NTGMyCommentCell *)button.superview.superview;
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        if (indexPath != nil) {
            NTGMyComment *model = _dataArray[indexPath.row];
            //long ID = _dataArray[indexPath.row];
            NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
            result.onSuccess = ^(id object){
                //        NSArray *article = page.content;
                //        if (article.count == 0) {
                //            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
                //            self.tableView.tableFooterView = view;
                //            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                //            label.text = @"已到加载全部了~";
                //            label.textAlignment = NSTextAlignmentCenter;
                //            [view addSubview:label];
                //        }else{
                //            [self updateTableView:article action:action state:YES];
                //        }
                //        [self.tableView reloadData];
                //        [_dataArray removeObjectAtIndex:indexPath.row];
                //        if (_dataArray.count == 0) {
                //            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
                //            self.tableView.tableFooterView = view;
                //            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
                //            label.text = @"还没有评论快快去评论吧~";
                //            label.textAlignment = NSTextAlignmentCenter;
                //            [view addSubview:label];
                //        }
                //
                //        [self.tableView reloadData];
                [self removeHud];
                [self initData];
                
            };
            [self addHudWithMessage:@"正在删除"];
            [NTGSendRequest deleteComment:@{@"commentId": [NSString stringWithFormat:@"%ld",model.id]} success:result];
        }


    }else{
    
        [NTGMBProgressHUD alertView:@"不可重复点击" view:self.view];
    }
    clickCount = 2;


    


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
