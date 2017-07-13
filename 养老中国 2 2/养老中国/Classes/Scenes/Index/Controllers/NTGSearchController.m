/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGSearchController.h"
#import "NTGSearchCell.h"
#import "NTGSearchReusableView.h"
#import "NTGSearchArticleController.h"
#import "DBManager.h"

/**
 *  control - 搜索页面
 */
@interface NTGSearchController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *searchView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic,strong) NSMutableArray *hotWordsArray;
@property (nonatomic,strong) NSMutableArray *historyArray;
@end

@implementation NTGSearchController
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _searchView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
    NSArray *array = [[DBManager shareManager] selectAllSearchHistory];
    _historyArray = [NSMutableArray arrayWithArray:array];
    [self.collectionView reloadData];
    _searchTF.text = nil;
    _searchTF.returnKeyType = UIReturnKeySearch;
    [_searchTF resignFirstResponder];
}
-(void)creatFlowLayout{
    _historyArray = [NSMutableArray array];
    _hotWordsArray = [NSMutableArray array];
   // _dataArray = [NSMutableArray arrayWithObjects:@"李克强",@"北京",@"里约奥运",@"傅园慧",@"王宝强",@"中国女排", nil];
   // _historyArray = [NSMutableArray arrayWithObjects:@"李克强",@"北京",@"里约奥运",@"傅园慧",@"王宝强",@"中国女排", nil];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 8;
    flowLayout.minimumInteritemSpacing = 11;
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 36)/2.0 , 37);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 8, 11);
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 45);
    //flowLayout.footerReferenceSize = CGSizeMake(10, 10);
    //flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    

    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"NTGSearchCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"NTGSearchReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatFlowLayout];
    [self initData];
}

-(void)initData{
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NSArray *hotWords){
    
        _hotWordsArray = (NSMutableArray *)hotWords;
        [_collectionView reloadData];
    
    };
    [NTGSendRequest getHotSearchWords:@{@"count":@"6"} success:result];

}
-(void)setHotWordsArray:(NSMutableArray *)hotWordsArray{
    _hotWordsArray = hotWordsArray;
    [self.collectionView reloadData];
}

- (IBAction)searchAction:(id)sender {
    if (_searchTF.text.length > 0) {
        
        if ([_historyArray indexOfObject:_searchTF.text] == NSNotFound) {
            [[DBManager shareManager] saveSearchHistory:_searchTF.text Success:^(BOOL result) {
            }];
        }
        NTGSearchArticleController *controller = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"searchResult"];
        controller.keyWord = _searchTF.text;
        [self.navigationController pushViewController:controller animated:YES];

    }else{
    
        [NTGMBProgressHUD alertView:@"请输入搜索内容" view:self.view];
        return;
    }
    
}

#pragma mark - textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        return NO;
    }
    if (_searchTF.text.length > 0) {
        
        if ([_historyArray indexOfObject:_searchTF.text] == NSNotFound) {
            [[DBManager shareManager] saveSearchHistory:_searchTF.text Success:^(BOOL result) {
            }];
        }
        NTGSearchArticleController *controller = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"searchResult"];
        controller.keyWord = _searchTF.text;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        
        [NTGMBProgressHUD alertView:@"请输入搜索内容" view:self.view];
        return YES;
    }

    /***  每搜索一次   就会存放一次到历史记录，但不存重复的*/
//    if ([self.searchArray containsObject:[NSDictionary dictionaryWithObject:textField.text forKey:@"content_name"]]) {
//        return YES;
//    }
    //[self reloadData:textField.text];
    return YES;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 2;
   
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NTGSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.model = _hotWordsArray[indexPath.row];
        return cell;

    }else {
       // collectionView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];

        NTGSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.model = _historyArray[indexPath.row];
       // cell.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        return cell;
    
    }
    

};


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _hotWordsArray.count;
    }
    return _historyArray.count;
 
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NTGSearchArticleController *controller = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"searchResult"];

    if (indexPath.section == 0) {
        controller.keyWord = _hotWordsArray[indexPath.row];
        
    }else{
        controller.keyWord = _historyArray[indexPath.row];
    
    }
    [self.navigationController pushViewController:controller animated:YES];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader){
            NTGSearchReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell" forIndexPath:indexPath];
            headerView.headerLabel.text = @"热门搜索";
            headerView.clearBtn.hidden = YES;
            reusableview = headerView;
        }

    }else if (indexPath.section == 1){
        if (kind == UICollectionElementKindSectionHeader){
            NTGSearchReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerCell" forIndexPath:indexPath];
            headerView.headerLabel.text = @"搜索历史";
            headerView.clearBtn.hidden = NO;
            [headerView.clearBtn addTarget:self action:@selector(clearHistoryAction) forControlEvents:UIControlEventTouchUpInside];
           // headerView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
            reusableview = headerView;
        }
    }
    
    return reusableview;
}
-(void)clearHistoryAction{
    [[DBManager shareManager] deleteSearchHistory];
    _historyArray = [NSMutableArray arrayWithArray:[[DBManager shareManager] selectAllSearchHistory]];
    [_collectionView reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
