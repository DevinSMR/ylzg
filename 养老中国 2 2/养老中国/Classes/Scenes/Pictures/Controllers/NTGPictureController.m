/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */


#import "NTGPictureController.h"
#import "NTGSendRequest.h"
#import "NTGBusinessResult.h"
#import "NTGAd.h"
#import "NTGArticle.h"
#import "NTGPage.h"
#import "NTGGeneralCell.h"
#import "NTGAdPosition.h"
#import "MRCycleView.h"
#import "NJBannerView.h"
#import "NTGPicturesCell.h"
#import "NTGPictureDetailController.h"
#import "NTGSearchController.h"
/**
 *  control - 图片频道
 */
@interface NTGPictureController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *articleTable;
//文章数组
@property (nonatomic,strong) NSMutableArray *dataArray;
//轮播图数组
@property (nonatomic,strong) NSMutableArray *adArray;
//轮播图
@property (nonatomic,strong) NJBannerView *cycleView;

//searchBar
@property (nonatomic,strong) UIButton *searchBar;
//是否显示searchBar
@property (nonatomic,assign) BOOL isShowSearchBar;

@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong) NSMutableDictionary *reqParam;
@end

@implementation NTGPictureController
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"NTGRequestError" object:nil];
    [self setupUI];
    //[self initData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)InfoNotificationAction:(NSNotification *)notification{
    
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"NTGRequestError" object:nil];
    
    NSLog(@"%@",notification.userInfo);
    [self removeHud];
    [self.articleTable.mj_header endRefreshing];
    [NTGMBProgressHUD alertView:@"请检查网络链接是否通畅" view:self.view];
    
}
//初始化视图
-(void)setupUI{
    //添加tableView
    self.articleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW,ScreenH )];
    self.articleTable.delegate = self;
    self.articleTable.dataSource = self;
    
    self.articleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //self.searchBar.hidden = YES;
    //[self.view bringSubviewToFront:self.searchBar];
    //添加手势
    
    [self.view addSubview:_articleTable];
    [self.articleTable registerNib:[UINib nibWithNibName:@"NTGPicturesCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self addSearch];
    //下拉刷新
    self.articleTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshDown];
    }];
    
    //上拉加载
    self.articleTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshUp];
        
    }];
    [self pageInitData:NTGPulRefreshInit];
    self.articleTable.contentOffset = CGPointMake(0, 58);
    
    
}

-(void)addSearch{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 58)];
    view.backgroundColor = [UIColor colorWithRed:245 / 255.0f green:245 / 255.0f blue:245 / 255.0f alpha:1];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(12, 9, ScreenW - 22,40)];
    searchView.layer.cornerRadius = 20;
    searchView.layer.borderWidth = 1;
    searchView.layer.borderColor = [[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1] CGColor];
    
    UIImageView *searchImV = [[UIImageView alloc] initWithFrame:CGRectMake(19, 10, 20, 20)];
    searchImV.image = [UIImage imageNamed:@"index_search"];
    [searchView addSubview:searchImV];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(54, 10, ScreenW - 86,20 );
    //button.backgroundColor = [UIColor redColor];
    [button setTitle:@"请输入搜索内容" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchView addSubview:button];
    self.searchBar = button;
    [view addSubview:searchView];
    
        [self.searchBar addTarget:self action:@selector(searchBarAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *tmpView = _articleTable.tableFooterView;
    tmpView.frame = CGRectMake(0, 0, ScreenW, 58);
    _articleTable.tableHeaderView = tmpView;
    _articleTable.tableHeaderView = view;
}

-(BOOL)searchBarAction:(UISearchBar *)searchBar
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    NTGSearchController *search = [storyboard instantiateInitialViewController];
    // NTGSearchController *searchVC = [[NTGSearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    return YES;
    
}


-(void)setAdArray:(NSMutableArray *)adArray
{
    _adArray = adArray;
    NSMutableArray *array = [NSMutableArray new];
    for (NTGArticle *ad in _adArray) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:ad.image forKey:@"img"];
        [dict setValue:ad.path forKey:@"link"];
        [array addObject:dict];
    }
    self.cycleView.datas = [NSMutableArray arrayWithArray:array];
    [self.articleTable reloadData];
}
-(void)initData{
    //请求最新文章数据
    self.dataArray = [NSMutableArray array];
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGPage *page){
        self.dataArray = [NSMutableArray arrayWithArray:page.content];
    };
     [NTGSendRequest getListPictures:nil success:result];
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
        if (article.count == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            self.articleTable.tableFooterView = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            label.text = @"已经到底部！";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            [self removeHud];
        }else{
            [self updateTableView:article action:action state:YES];
            [self removeHud];
            
        }
    };
    //检测网络状态
    if ([NTGDetection netStatus] == NotReachable) {
        [NTGMBProgressHUD alertView:@"网络连接异常" view:self.view];
    }else{
        [self addHudWithMessage:@"加载中..."];
        [NTGSendRequest getListPictures:self.reqParam success:result];
    }

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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PictureDetail" bundle:nil];
    NTGPictureDetailController *generalVC = [storyboard instantiateInitialViewController];
    NTGArticle *article = self.dataArray[indexPath.row];
    if (article.articleImage.count > 0) {
        generalVC.article = article;
        [self.navigationController pushViewController:generalVC animated:YES];

    }else{
        [NTGMBProgressHUD alertView:@"暂无详情" view:self.view];;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenW - 20) * 398 / 708.0 + 76 + 20;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
@end
