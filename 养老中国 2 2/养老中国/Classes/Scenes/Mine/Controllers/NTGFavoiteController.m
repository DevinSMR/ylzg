//
//  NTGFavoiteController.m
//  养老中国
//
//  Created by nbc on 16/8/25.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGFavoiteController.h"
#import "NTGConstant.h"
#import "NTGPage.h"
#import "NTGArticle.h"
#import "NTGNewsDetailController.h"
#import "NTGPictureDetailController.h"
#import "NTGVideoDetailController.h"
#import "NTGGeneralCell.h"
#import "NTGFavoiteEditCell.h"
#import "NTGWebVideoController.h"
#import "NTGMyFavorite.h"
@interface NTGFavoiteController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

//文章数组
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableDictionary *reqParam;
//加载页面中
@property (nonatomic,retain) MBProgressHUD* hud;

//被选中文章的ID;
@property (nonatomic,strong) NSMutableArray *articleIDArray;

//是否在编辑状态下
@property (nonatomic,assign) BOOL isEdit;

@end

@implementation NTGFavoiteController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
   // [self pageInitData:NTGPulRefreshInit];
    //[self initData];

}
- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    self.dataArray = [NSMutableArray array];
    [self pageInitData:NTGPulRefreshInit];
   // [self initData];
}
/** 更新数据 */
- (void) initData{
    [self.reqParam setValue:@"1" forKey:@"pageNumber"];

    //请求最新文章数据
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGPage *page){
        
      //  self.dataArray =[NSMutableArray arrayWithArray:page.content];
//        if (_dataArray.count == 0) {
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//            self.tableView.tableFooterView = view;
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
//            label.text = @"还没有收藏快快去收藏吧~";
//            label.textAlignment = NSTextAlignmentCenter;
//            [view addSubview:label];
//        }
       // [self.tableView reloadData];
    };
    [NTGSendRequest getlistfavorite:self.reqParam success:result];
}


- (IBAction)editBtnAction:(UIButton *)sender {
    if (self.dataArray.count != 0) {
        if ([self.editBtn.titleLabel.text isEqualToString:@"编辑"]) {
            [self.editBtn setTitle:@"取消" forState:UIControlStateNormal];
            //[self pageInitData:NTGPulRefreshInit];
            //[self initData];
            self.deleteBtn.hidden = NO;
            [self.tableView reloadData];
            
        }
        else if ([self.editBtn.titleLabel.text isEqualToString:@"取消"]){
            [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            //[self initData];
            self.deleteBtn.hidden = YES;
            [self.tableView reloadData];
        }

    }
}

- (IBAction)deleteSaveAction:(id)sender {
    if (self.dataArray.count != 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除收藏？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteSave];
        }];
        UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:cancelAction2];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//删除收藏
-(void)deleteSave{

    NSString *deleteIDs = [self getAllSelectArticleIds];
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(id object){
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.deleteBtn.hidden = YES;
        [self.tableView.tableFooterView removeFromSuperview];
        [self pageInitData:NTGPulRefreshInit];
    };
    [NTGSendRequest cancelFavorite:@{@"ids":deleteIDs} success:result];
}
-(void)setupUI{
    //[self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NTGGeneralCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   // [self.tableView registerNib:[UINib nibWithNibName:@"NTGFavoiteEditCell" bundle:nil] forCellReuseIdentifier:@"editCell"];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshDown];
    }];
    
    //上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pageInitData:NTGPulRefreshUp];
        
    }];
    _isEdit = YES;

}
- (void) pageInitData :(NTGPullRefresh)action {
    if (action == NTGPulRefreshInit || action == NTGPulRefreshDown) {
        // [self.reqParam setObject:@"1" forKey:@"pageNumber"];
        self.reqParam = [NSMutableDictionary new];
        [self.reqParam setValue:@"1" forKey:@"pageNumber"];
        [self.reqParam setValue:@"7" forKey:@"pageSize"];
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
        if (article.count == 0 && action == NTGPulRefreshUp) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            self.tableView.tableFooterView = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            label.text = @"已到加载全部了~";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            [self.tableView.mj_footer endRefreshing];

        }else if(article.count == 0 && action == NTGPulRefreshInit){
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            self.tableView.tableFooterView = view;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            label.text = @"还没有收藏快快去收藏吧~";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            self.dataArray = [NSMutableArray array];
            [self.tableView.mj_header endRefreshing];
            
        }else{
        
            [self updateTableView:article action:action state:YES];
        }
        //[self.tableView reloadData];
    };
    [NTGSendRequest getlistfavorite:self.reqParam success:result];
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

//初始化数据
-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
    
}

- (void)addDataArray:(NSArray *)dataArray {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_dataArray];
    [temp addObjectsFromArray:dataArray];
    _dataArray= temp;
    [self.tableView reloadData];
}

-(void) clearDataArray {
    _dataArray = [NSMutableArray array];
   // [self.tableView reloadData];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NTGGeneralCell *cell = nil;
    if ([self.editBtn.titleLabel.text isEqualToString:@"编辑"]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        _isEdit = YES;
        
    } else if([self.editBtn.titleLabel.text isEqualToString:@"取消"]){
       // [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        cell = [tableView dequeueReusableCellWithIdentifier:@"editCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NTGFavoiteEditCell" owner:nil options:nil]lastObject];
        }
        [cell.selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _isEdit = NO;
    }
    NTGMyFavorite *favorite = self.dataArray[indexPath.row];
    
    cell.article = favorite.article;
    if (cell.article.tag == NO) {
        cell.selectBtn.selected = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(void)selectBtnAction:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    NTGGeneralCell *cell = (NTGGeneralCell *)btn.superview.superview;
    cell.article.tag = btn.selected;
    NSString *articleID = [self getAllSelectArticleIds];
    if (![articleID isEqualToString:@""]) {
        self.deleteBtn.enabled = YES;
        [self.deleteBtn setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
        self.deleteBtn.backgroundColor = [UIColor colorWithRed:0 green:104/255.0 blue:183/255.0 alpha:1];
    }else{
        self.deleteBtn.enabled = NO;
        [self.deleteBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
        self.deleteBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
}

/** 获取选中的文章的ID */
- (NSString *)getAllSelectArticleIds {
    NSString *cid = @"";
    self.articleIDArray = [NSMutableArray array];
    for (int j = 0; j < self.dataArray.count; j++) {
        NTGMyFavorite *favorite = self.dataArray[j];

        NTGArticle *article = favorite.article;
        if (article.tag) {
            cid = [cid stringByAppendingString:[NSString stringWithFormat:@"%ld", article.id]];
            [self.articleIDArray addObject:[NSString stringWithFormat:@"%ld", article.id]];
            
            cid = [cid stringByAppendingString:@","];
        }
    }
    if (cid.length > 0) {
        cid = [cid substringToIndex:cid.length - 1];

    }
    return cid;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEdit) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil];
        NTGNewsDetailController *generalVC = [storyboard instantiateInitialViewController];
        NTGMyFavorite *favorite = self.dataArray[indexPath.row];

        NTGArticle *article = favorite.article;
        if ([article.tagType isEqualToString:@"media"]) {
            if (article.media == nil && article.links == nil) {
                [NTGMBProgressHUD alertView:@"暂无详情" view:self.view];
            }
            else {
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
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//wochengzuode hangban
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
