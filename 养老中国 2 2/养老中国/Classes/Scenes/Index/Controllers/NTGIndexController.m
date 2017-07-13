/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGIndexController.h"
#import "UIImageView+WebCache.h"
#import "NTGClassificationScrollView.h"
#import "NTGBusinessResult.h"
#import "NTGSendRequest.h"
#import "NTGAdPosition.h"
#import "NTGCultureController.h"
#import "NTGNewestController.h"
#import "NTGNewsController.h"
#import "NTGVideosController.h"
#import "NTGPictureController.h"
#import "NTGTechnologyController.h"
#import "UIView+Extension.h"
#import "NTGMineController.h"
#import "TencentNewsViewController.h"
#import "LFCGzipUtillity.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@interface NTGIndexController ()<UIScrollViewDelegate,NTGCLassifictionScorllViewBtnDelegate,UIAlertViewDelegate>
//首页滚动视图
@property (nonatomic,strong) UIScrollView *backgroundScrollView;
//分类按钮的数组
@property (nonatomic,strong) NSMutableArray *itemsBtnArray;
//中间替换Btn
@property (nonatomic,strong) UIButton *tmpBtn;
@property (nonatomic,strong) NTGClassificationScrollView *classificationView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,assign) NSInteger index;
//当前版本号，用来和服务器端的进行比对
@property (nonatomic,assign) int version;
@end
/**
 *  control - 首页
 */
@implementation NTGIndexController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self setupChildViewControllers];
    [self addScrollView];
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    //默认开始显示第一个界面
    [self scrollViewDidEndScrollingAnimation:self.scrollView];

    [self initData];
   // [self showAlertview];
    [self checkVersion];
    
}
-(void)initData{
//    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
//
//      result.onSuccess = ^(id response){
//        NSLog(@"这个结果是：%@",response);
//    
//    };
//  NSDictionary *dict = @{@"mobile":@"18610616044"};
//    [NTGSendRequest getSMSValidCode:dict success:result];
    
//    NSDictionary  *dicts = @{
//                             
//                             @"validCodeKey":@"b4d96641-bac8-4637-9ac1-95f9e716c368",
//                             @"validCodeValue":@"688012"
//                             };
//
//   [NTGSendRequest registercheck_SMSValidCode:dicts success:result];
    
//    NSDictionary *dict = @{@"id":@"7775"};
//    [NTGSendRequest setPraise:dict success:result];
    
    
}

//初始化所有子控制器
-(void)setupChildViewControllers{

    
    //增加导航栏视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
   // UIColor *color = [self stringTOColor:@"#0068b7"];
   // view.backgroundColor = color;
    view.backgroundColor = [UIColor colorWithRed:0 green:104 /255.0f blue:183 / 255.0f alpha:1];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW / 2 - 49, 20, 98, 37)];
    //imgView.backgroundColor = [UIColor redColor];
    imgView.image = [UIImage imageNamed:@"logo_index"];
    
    [view addSubview:imgView];
    [view bringSubviewToFront:imgView];
    
    UIImageView *mineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW - 33, 30, 20, 20)];
    mineImgV.image = [UIImage imageNamed:@"index_mine"];
    mineImgV.contentMode = UIViewContentModeScaleToFill;
    [view addSubview:mineImgV];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setImage:[UIImage imageNamed:@"index_mine"] forState:UIControlStateNormal];
    button.frame = CGRectMake(ScreenW - 50, 0, 50, 50);
    [button addTarget:self action:@selector(pushToMyCenter) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [self.view addSubview:view];
    
    
    //初始化头部视图
    self.classificationView = [NTGClassificationScrollView creatClassificationView];
    self.classificationView.myDelegate = self;
    self.itemsBtnArray = [NSMutableArray array];
    self.itemsBtnArray = _classificationView.itemBtnArray;
    [self.view addSubview:_classificationView];
    
    
    
    //初始化子控制器
    NTGNewestController *newestVC = [[NTGNewestController alloc] init];
    [self addChildViewController:newestVC];
    
    NTGNewsController *newsVC = [[NTGNewsController alloc] init];
    [self addChildViewController:newsVC];
    
    NTGPictureController *pictureVC = [[NTGPictureController alloc] init];
    [self addChildViewController:pictureVC];
    
    NTGCultureController *cultureVC = [[NTGCultureController alloc] init];
    [self addChildViewController:cultureVC];
    
//    NTGVideosController *videosVC = [[NTGVideosController alloc] init];
//    [self addChildViewController:videosVC];
    TencentNewsViewController *videosVC = [[TencentNewsViewController alloc] init];
    [self addChildViewController:videosVC];
    
    NTGTechnologyController *technologyVC = [[NTGTechnologyController alloc] init];
    [self addChildViewController:technologyVC];

}
-(void)pushToMyCenter{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    NTGMineController *mineVC = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:mineVC animated:YES];
    


}
//将十六进制的颜色字符串转为相应的颜色
- (UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

//铺设首页六个页面
-(void)addScrollView;
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, ScreenW, ScreenH )];
    scrollView.contentSize = CGSizeMake(ScreenW * 6, 0);
    [self.view addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    _scrollView = scrollView;

}
//代理方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _tmpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    self.tmpBtn.selected = NO;
    NSInteger tag = (self.scrollView.contentOffset.x )/ ScreenW + 101;
    UIButton *button = (UIButton *)[self.classificationView viewWithTag:tag];
    button.selected = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:21];
    self.tmpBtn = button;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    //当前的索引
    _index = scrollView.contentOffset.x / scrollView.width;
    NSLog(@"当前的索引%ld",_index);
    NSString *indexStr = [NSString stringWithFormat:@"%ld",_index];
    [indexStr addObserver:self forKeyPath:@"indexStr" options:NSKeyValueObservingOptionNew || NSKeyValueChangeOldKey context:nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%ld",_index] forKey:@"offset"];
    
    //取出子控制器
    UIViewController *childVC = self.childViewControllers[_index];
    childVC.view.x = scrollView.contentOffset.x;
    childVC.view.y = -64;
    childVC.view.height = scrollView.height;
    [scrollView addSubview:childVC.view];


}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [self.view bringSubviewToFront:self.searchBar];
    //当前的索引
    _index = scrollView.contentOffset.x / scrollView.width;
    NSLog(@"当前的索引%ld",_index);
    //取出子控制器
    UIViewController *childVC = self.childViewControllers[_index];
    childVC.view.x = scrollView.contentOffset.x;
    childVC.view.y = -64;
    childVC.view.height = scrollView.height;
    [scrollView addSubview:childVC.view];

}
//当选择分类按钮时让scrollView滚动的方法
-(void)didClickBtnAction:(UIButton *)sender
{
    _index = sender.tag - 101;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%ld",_index] forKey:@"offset"];

    self.scrollView.contentOffset = CGPointMake(_index * ScreenW , 0);
    [self scrollViewDidEndDecelerating:self.scrollView];

}
//为scrollView增加视图
-(UIView *) addBackgroundViewWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    CGFloat redColor = arc4random()%256/255.0;
    CGFloat greenColor = arc4random()%256/255.0;
    CGFloat blueColor = arc4random()%256/255.0;
    view.backgroundColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1];
    return view;
}

-(BOOL)checkVersionUpdate{
//拼接链接、转成URL
    NSString *checkUrlString = @"https://itunes.apple.com/us/app/yang-lao-zhong-guo-wang/id1150994257?l=zh&ls=1&mt=8";
    NSURL *checkUrl = [NSURL URLWithString:checkUrlString];
    
    //获取网络数据AppStore上的app信息
    NSString *appInfoString = [NSString stringWithContentsOfURL:checkUrl encoding:NSUTF8StringEncoding error:nil];
    //字符串转json转字典
    NSData *JSONData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    if (appInfo) {
        NSArray *resultAry = appInfo[@"results"];
        NSDictionary *resultDic = resultAry.firstObject;
        
        //版本号
        NSString *version = resultDic[@"version"];
        
        //应用名称
        NSString *trackCensoredName = resultDic[@"trackName"];
        
        //下载地址
        NSString *trackViewUrl = resultDic[@"trackViewUrl"];
        
        
        return [self compareVersion:version];
    }else{
        return NO;
    
    }
    
}


-(BOOL)compareVersion:(NSString *)serverVersion{

    //获取当前版本号
    NSDictionary *infoDic =[[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    if ([appVersion compare:serverVersion] == NSOrderedAscending) {
        NSLog(@"发现新版本 %@",serverVersion);
        return YES;
    }else{
        NSLog(@"没有发现新版本");
        return NO;
    
    }
    
    
}

#pragma mark -- 获取数据
-(void)Postpath:(NSString *)path
{
    
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error){
        NSMutableDictionary *receiveStatusDic=[[NSMutableDictionary alloc]init];
        if (data) {
            
            NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([[receiveDic valueForKey:@"resultCount"] intValue]>0) {
                
                [receiveStatusDic setValue:@"1" forKey:@"status"];
                [receiveStatusDic setValue:[[[receiveDic valueForKey:@"results"] objectAtIndex:0] valueForKey:@"version"]   forKey:@"version"];
            }else{
                
                [receiveStatusDic setValue:@"-1" forKey:@"status"];
            }
        }else{
            [receiveStatusDic setValue:@"-1" forKey:@"status"];
        }
        
        [self performSelectorOnMainThread:@selector(receiveData:) withObject:receiveStatusDic waitUntilDone:NO];
    }];
    
}


-(void)receiveData:(id)sender
{
    NSLog(@"receiveData=%@",sender);
    
}

#pragma mark - 弹出更新的提醒
-(void)checkVersion{
    _version = 4;
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(id object){
        NSDictionary *versionDict = (NSDictionary *)object;
        NSNumber *versionStr = versionDict[@"versionCode"];
        int currentVersion = [versionStr intValue];
        if (currentVersion > _version) {
            [self showAlertview];
        }
    };
    [NTGSendRequest checkVersion:nil success:result];

}

-(void)showAlertview{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本是否更新" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新",@"下次提醒" ,nil];
    alert.frame = CGRectMake(0, 0, 400, 300);
    [alert show];



}
- (void)willPresentAlertView:(UIAlertView *)alertView {
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //APP的下载地址
        NSString *str = @"https://itunes.apple.com/us/app/%E5%85%BB%E8%80%81%E4%B8%AD%E5%9B%BD-%E4%B8%AD%E5%9B%BD%E6%9C%80%E4%B8%93%E4%B8%9A%E7%9A%84%E5%85%BB%E8%80%81%E8%B5%84%E8%AE%AF%E7%BD%91%E7%AB%99/id1216507128?l=zh&ls=1&mt=8";

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }



}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"indexStr"];

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
