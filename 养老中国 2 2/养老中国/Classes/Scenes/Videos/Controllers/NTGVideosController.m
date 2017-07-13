//
//  NTGVideosController.m
//  养老中国
//
//  Created by nbc on 16/7/20.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGVideosController.h"
#import "NTGSendRequest.h"
#import "NTGBusinessResult.h"
#import "NTGAd.h"
#import "NTGArticle.h"
#import "NTGPage.h"
#import "NTGVideoCell.h"
#import "NTGAdPosition.h"
#import "MRCycleView.h"
#import "NJBannerView.h"
#import <MJRefresh.h>
#import "NTGConstant.h"
#import "WMPlayer.h"
#import "Masonry.h"
@interface NTGVideosController ()<UITableViewDelegate,UITableViewDataSource,WMPlayerDelegate>
@property (nonatomic,strong) UITableView *articleTable;
//文章数组
@property (nonatomic,strong) NSMutableArray *dataArray;



//searchBar
@property (nonatomic,strong) UISearchBar *searchBar;
//是否显示searchBar
@property (nonatomic,assign) BOOL isShowSearchBar;

//刷新参数
@property (nonatomic,strong) NSMutableDictionary *reqParam;


@end

@implementation NTGVideosController
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //[self initData];
    self.dataArray = [NSMutableArray array];
    [self pageInitData:NTGPulRefreshInit];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.articleTable.contentOffset = CGPointMake(0, 58);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];

    //屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
}



//初始化视图
-(void)setupUI{
    //添加tableView
    self.articleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW,ScreenH )];
    self.articleTable.delegate = self;
    self.articleTable.dataSource = self;
    
    self.articleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_articleTable];
    [self.articleTable registerNib:[UINib nibWithNibName:@"NTGVideoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //下拉刷新
    self.articleTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshDown];
    }];
    
    //上拉加载
    self.articleTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshUp];
        
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
        if (article.count == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            self.articleTable.tableFooterView = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            label.text = @"已经到底部！";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
        }else{
            [self updateTableView:article action:action state:YES];
            
            
        }
    };
    [NTGSendRequest getListVideos:self.reqParam success:result];
    
    
    
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



#pragma mark - UITableView的代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTGVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NTGVideoCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.article = self.dataArray[indexPath.section];
    NSLog(@"%ld",indexPath.section);
    cell.index = indexPath.section;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenW - 20) * 398 / 708.0 + 76;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 
}
-(void)dealloc{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



@end
