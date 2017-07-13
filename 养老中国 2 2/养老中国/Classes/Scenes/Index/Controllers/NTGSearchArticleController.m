/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGSearchArticleController.h"
#import "NTGArticle.h"
#import "NTGPage.h"
#import "NTGGeneralCell.h"
#import "NTGNewsDetailController.h"
#import "NTGPictureDetailController.h"
#import "NTGVideoDetailController.h"
#import <MJRefresh.h>
#import "NTGConstant.h"
#import "NTGWebVideoController.h"

/**
 *  control - 搜索结果
 */
@interface NTGSearchArticleController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *articleTable;
//文章数组
@property (nonatomic,strong) NSMutableArray *dataArray;
//轮播图数组
@property (nonatomic,strong) NSMutableArray *adArray;

@property (nonatomic,strong) NSMutableDictionary *reqParam;
//当前点击的第几条内容
@property (nonatomic,assign) NSInteger index;

//加载页面中
@property (nonatomic,retain) MBProgressHUD* hud;

@end

@implementation NTGSearchArticleController
- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.dataArray = [NSMutableArray array];
   // [self initData];
    [self pageInitData:NTGPulRefreshInit];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)initData{
    self.reqParam = [NSMutableDictionary new];
   // [self.reqParam setValue:@"1" forKey:@"pageNumber"];
    [self.reqParam setValue:@"20" forKey:@"pageSize"];
    [self.reqParam setValue:_keyWord forKey:@"keyword"];

    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGPage *page){
        
        _dataArray = (NSMutableArray *)page.content;
        if (page.content.count == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
            self.articleTable.tableFooterView = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, view.frame.size.width, view.frame.size.height)];
            label.text = @"没有相关内容";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            [self removeHud];
        }else{
            [self removeHud];
        }
        [self.reqParam setValue:@"2" forKey:@"pageNumber"];

        [self.articleTable reloadData];
    };
    [self addHudWithMessage:@"加载中..."];
    [NTGSendRequest getSearchArticle:_reqParam success:result];
}
//初始化视图
-(void)setupUI{
    //添加tableView
    self.articleTable.delegate = self;
    self.articleTable.dataSource = self;
    self.articleTable.showsVerticalScrollIndicator = NO;
    //self.articleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_articleTable];
    
    [self.articleTable registerNib:[UINib nibWithNibName:@"NTGGeneralCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
     //下拉刷新
    self.articleTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshDown];
    }];
    
    //上拉加载
    self.articleTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshUp];
        
    }];
    //必须将所有空间添加完再设置偏移量才能正确执行，否则不能实现效果
    //self.articleTable.contentOffset = CGPointMake(0, 58);
    
    
    
}
- (void) pageInitData :(NTGPullRefresh)action {
    if (action == NTGPulRefreshInit || action == NTGPulRefreshDown) {
        // [self.reqParam setObject:@"1" forKey:@"pageNumber"];
        self.reqParam = [NSMutableDictionary new];
        [self.reqParam setValue:@"1" forKey:@"pageNumber"];
        [self.reqParam setValue:@"20" forKey:@"pageSize"];
        [self.reqParam setValue:_keyWord forKey:@"keyword"];
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
        if (article.count == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            self.articleTable.tableFooterView = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            label.text = @"已经到底部！";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            [self removeHud];
        }else{
            [self removeHud];
            [self updateTableView:article action:action state:YES];
        }
    };
    [self addHudWithMessage:@"加载中..."];
    [NTGSendRequest getSearchArticle:_reqParam success:result];
    
    
    
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
        _hud=nil;
    }
}


- (void) updateTableView:(NSArray *)dataArray action:(NTGPullRefresh)action state:(BOOL) state {
    if (action == NTGPulRefreshDown || action == NTGPulRefreshInit) {//表示是下拉刷新、初始化加载
        if (state) {
            [self clearDataArray];
        }
        
        if (action == NTGPulRefreshDown) {
            [self.articleTable.mj_header endRefreshing];
        }
        
    }
    else{//上拉加载
        if (dataArray.count == 0) {
            [self.articleTable.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.articleTable.mj_footer endRefreshing];
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

//初始化数据
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.articleTable reloadData];
    
}

- (void)addDataArray:(NSArray *)dataArray {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_dataArray];
    [temp addObjectsFromArray:dataArray];
    _dataArray= temp;
    [self.articleTable reloadData];
}

-(void) clearDataArray {
    _dataArray = [NSMutableArray array];
    [self.articleTable reloadData];
}



-(void)setAdArray:(NSMutableArray *)adArray
{
    _adArray = adArray;
    [self.articleTable reloadData];
}
#pragma mark - UITableView的代理方法


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTGGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NTGGeneralCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.article = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当返回的时候取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.index = indexPath.row;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil];
    NTGNewsDetailController *generalVC = [storyboard instantiateInitialViewController];
    NTGArticle *article = self.dataArray[indexPath.row];
    if ([article.tagType isEqualToString:@"media"]) {
        if (article.media == nil && article.links == nil) {
            [NTGMBProgressHUD alertView:@"暂无详情" view:self.view];
        } else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil];
            NTGWebVideoController *webViewVC = [storyboard instantiateViewControllerWithIdentifier:@"webVideo"];
            webViewVC.article = article;
            [self.navigationController pushViewController:webViewVC animated:YES];
        }
        
    }else if([article.tagType isEqualToString:@"image"]){
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
        generalVC.article = article;
        [self.navigationController pushViewController:generalVC animated:YES];
    }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 
}
@end
