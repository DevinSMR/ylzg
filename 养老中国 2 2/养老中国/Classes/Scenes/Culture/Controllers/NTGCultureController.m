//
//  NTGCultureController.m
//  养老中国
//
//  Created by nbc on 16/7/20.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGCultureController.h"
#import "NTGSendRequest.h"
#import "NTGBusinessResult.h"
#import "NTGAd.h"
#import "NTGArticle.h"
#import "NTGPage.h"
#import "NTGGeneralCell.h"
#import "NTGAdPosition.h"
#import "MRCycleView.h"
#import "NJBannerView.h"
#import <MJRefresh.h>
#import "NTGConstant.h"
#import "NTGSearchController.h"
#import "NTGNewsDetailController.h"
#import "NTGPictureDetailController.h"
#import "NTGVideoDetailController.h"
#import "NTGWebVideoController.h"
@interface NTGCultureController ()<UITableViewDelegate,UITableViewDataSource,NJBannerViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *articleTable;
//文章数组
@property (nonatomic,strong) NSMutableArray *dataArray;
//轮播图数组
@property (nonatomic,strong) NSMutableArray *adArray;
//轮播图
@property (nonatomic,strong) NJBannerView *cycleView;

//searchBar
@property (nonatomic,strong) UISearchBar *searchBar;
//是否显示searchBar
@property (nonatomic,assign) BOOL isShowSearchBar;

//当前点击的第几条内容
@property (nonatomic,assign) NSInteger index;

//加载页面中
@property (nonatomic,retain) MBProgressHUD* hud;

@property (nonatomic,strong) NSMutableDictionary *reqParam;
@end

@implementation NTGCultureController
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //[self initData];
    self.dataArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"NTGRequestError" object:nil];
    [self pageInitData:NTGPulRefreshInit];
    
    //请求轮播图的数据
    [self requestCycleViewData];
    
}
- (void)InfoNotificationAction:(NSNotification *)notification{
    
    //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"NTGRequestError" object:nil];
    
    NSLog(@"%@",notification.userInfo);
    [self removeHud];
    [self.articleTable.mj_header endRefreshing];
    [NTGMBProgressHUD alertView:@"请检查网络链接是否通畅" view:self.view];
    
}


-(void)requestCycleViewData{
    //请求轮播图数据
    self.adArray = [NSMutableArray new];
    NTGBusinessResult *result2 = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result2.onSuccess = ^(NTGPage *page){
        [self removeHud];
        self.adArray = [NSMutableArray arrayWithArray:page.content] ;
    };
    //检测网络状态
    if ([NTGDetection netStatus] == NotReachable) {
        [NTGMBProgressHUD alertView:@"网络连接异常" view:self.view];
    }else{
        [self addHudWithMessage:@"加载中..."];
        [NTGSendRequest getCultureBanner:self.reqParam success:result2];
    }

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
//初始化视图
-(void)setupUI{
    //添加tableView
    self.articleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW,ScreenH )];
    self.articleTable.delegate = self;
    self.articleTable.dataSource = self;
    self.articleTable.showsVerticalScrollIndicator = NO;
    self.articleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_articleTable];
    [self.articleTable registerNib:[UINib nibWithNibName:@"NTGGeneralCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //添加轮播图
    self.cycleView = [[NJBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 319)];
    self.cycleView.dataSouce = self;
    [self.cycleView.searchBar addTarget:self action:@selector(searchBarShouldBeginEditing:) forControlEvents:UIControlEventTouchUpInside];
    __weak __typeof(self)weakSelf = self;
    self.cycleView.linkAction = ^(NTGArticle *article){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil];
        NTGNewsDetailController *generalVC = [storyboard instantiateInitialViewController];
        if ([article.tagType isEqualToString:@"media"]) {
            if (article.media == nil && article.links == nil) {
                [NTGMBProgressHUD alertView:@"暂无详情" view:weakSelf.view];
            } else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil];
                NTGWebVideoController *webViewVC = [storyboard instantiateViewControllerWithIdentifier:@"webVideo"];
                webViewVC.article = article;
                [weakSelf.navigationController pushViewController:webViewVC animated:YES];
            }
            
        }else if([article.tagType isEqualToString:@"image"]){
            UIStoryboard *storyboard2 = [UIStoryboard storyboardWithName:@"PictureDetail" bundle:nil];
            NTGPictureDetailController *pictureVC =  [storyboard2 instantiateInitialViewController];
            pictureVC.article = article;
            if (article.articleImage.count > 0) {
                pictureVC.article = article;
                [weakSelf.navigationController pushViewController:pictureVC animated:YES];
                
            }else{
                [NTGMBProgressHUD alertView:@"暂无详情" view:weakSelf.view];;
            }
        }else{
            generalVC.article = article;
            [weakSelf.navigationController pushViewController:generalVC animated:YES];
        }
        
    };
    
    UIView *view = self.articleTable.tableHeaderView;
    view.frame = CGRectMake(0, 0, ScreenW, 319);
    self.articleTable.tableHeaderView = view;
    self.articleTable.tableHeaderView = _cycleView;
    
    //下拉刷新
    self.articleTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshDown];
        [self requestCycleViewData];

    }];
    
    //上拉加载
    self.articleTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshUp];
        
    }];
    self.articleTable.contentOffset = CGPointMake(0, 58);

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
            [self removeHud];
            [self updateTableView:article action:action state:YES];
        }
    };
    //检测网络状态
    if ([NTGDetection netStatus] == NotReachable) {
        [NTGMBProgressHUD alertView:@"网络连接异常" view:self.view];
    }else{
        [self addHudWithMessage:@"加载中..."];
        [NTGSendRequest getlistCulture:self.reqParam success:result];
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
    NSMutableArray *array = [NSMutableArray new];
    for (NTGArticle *ad in _adArray) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:ad.image forKey:@"img"];
        [dict setValue:ad.path forKey:@"link"];
        [dict setValue:ad.title forKey:@"title"];
        [dict setValue:ad.tagType forKey:@"type"];
        [dict setValue:ad forKey:@"article"];
        [array addObject:dict];
    }
    self.cycleView.datas = [NSMutableArray arrayWithArray:array];
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
    self.index = indexPath.row;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil];
    // NTGGeneralController *generalVC = [storyboard instantiateInitialViewController];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PictureDetail" bundle:nil];
        NTGPictureDetailController *pictureVC =  [storyboard instantiateInitialViewController];
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


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Search" bundle:nil];
    NTGSearchController *search = [storyboard instantiateInitialViewController];
    // NTGSearchController *searchVC = [[NTGSearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    
    return YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //
}



@end
