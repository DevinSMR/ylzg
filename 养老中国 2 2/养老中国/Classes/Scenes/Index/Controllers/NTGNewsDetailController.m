/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGNewsDetailController.h"
#import "NTGPictureDetailController.h"
#import "NTGVideoDetailController.h"
#import "NTGWebVideoController.h"
#import "NTGBusinessResult.h"
#import "NTGSendRequest.h"
#import "NTGArticle.h"
#import "NTGNewsDetailCell.h"
#import "NTGPage.h"
#import "NTGCommentCell.h"
#import "NTGCommentsController.h"
#import "NTGPraiseMembers.h"
#import "NTGGeneralCell.h"
#import "NTGNewsDetailShareCell.h"
#import <ShareSDK/ShareSDK.h>
#import "LLShareSDKTool.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "WXApi.h"
#import "WeiboSDK.h"

/**
 *  control - 新闻详情
 */
@interface NTGNewsDetailController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSString *strHtml;
@property (nonatomic,strong) UIWebView *webView;
//评论列表按钮
@property (weak, nonatomic) IBOutlet UIButton *priseBtn;
//说点什么的底部视图
@property (weak, nonatomic) IBOutlet UIView *mineCommentView;
//说点什么上的btn
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
//半透明视图
@property (weak, nonatomic) IBOutlet UIView *topView;
//评论输入底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//评论输入框
@property (weak, nonatomic) IBOutlet UITextView *comentTextView;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
//点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

//评论内容
@property (nonatomic,strong) NSMutableArray *commentArray;

//相关新闻
@property (nonatomic,strong) NSMutableArray *relatedArray;
//请求到的文章详情
@property (nonatomic,strong) NTGArticle *articleDetail;

//是否已经为评论点过赞
@property (nonatomic,assign) BOOL isPraiseComment;

//当前被点赞的评论cell
@property (nonatomic,strong) NTGCommentCell *currentCell;

//加载页面中
@property (nonatomic,retain) MBProgressHUD* hud;


//标题视图
@property (nonatomic,strong) UIView *titleView;

@end

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@implementation NTGNewsDetailController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//有哪些稍微一改动，意境马上大变的歌词
/*此处做一下说明，产品将评论列表功能放原来的点赞处，将点赞放分享处，将分享放评论列表处*/
//分享
- (IBAction)commentAction:(id)sender {
    //检测是否安装了微信和微博客户端，没有安装不显示分享页面
        if (![self checkWechatAndWeiboApp]) {
        return;
    }
  
    
    NSURL *url = [NSURL URLWithString:self.article.image];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *img;
    
    if (url) {
        if ([manager diskImageExistsForURL:url])
        {
            img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            
        }
        else
        {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
        }
        
    }else{
        img = [UIImage imageNamed:@"index_backImg"];
        
    }
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (self.article.paper.length > 100) {
        self.article.paper = [self.article.paper substringWithRange:NSMakeRange(0, 100)];
    }
    //
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",self.article.paper,self.article.sharePath]
                                         images:img
                                            url:[NSURL URLWithString:self.articleDetail.sharePath]
                                          title:self.articleDetail.title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
}


//我来说两句
- (IBAction)mineComentAction:(id)sender {
    
}
//点赞
- (IBAction)priseAction:(id)sender {
    
}
//点赞
- (IBAction)shareAction:(id)sender {
    NSDictionary *dict= @{@"id":[NSString stringWithFormat:@"%ld",self.article.id]};
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NSString *string) {
        if ([string isEqualToString:@"1"]) {
            _shareBtn.selected = YES;
            [NTGMBProgressHUD alertView:@"已点赞" view:self.view];
        }else{
            _shareBtn.selected = NO;
            [NTGMBProgressHUD alertView:@"已取消点赞" view:self.view];
        }
    };
    [NTGSendRequest setPraise:dict success:result];
}

//收藏
- (IBAction)saveAction:(id)sender {
    NSDictionary *dict= @{@"id":[NSString stringWithFormat:@"%ld",self.article.id]};
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NSString *string) {
        if ([string isEqualToString:@"1"]) {
            _saveBtn.selected = YES;
            [NTGMBProgressHUD alertView:@"已收藏" view:self.view];
        }else{
            _saveBtn.selected = NO;
            [NTGMBProgressHUD alertView:@"已取消收藏" view:self.view];
        }
    };
    [NTGSendRequest favoriteAdd:dict success:result];
//    if (btn.selected) {
//        [NTGMBProgressHUD alertView:@"您已收藏" view:self.view];
//    }

}

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(8, 0, SXSCREEN_W - 16 , CGFLOAT_MIN)];
        _webView = web;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
        _webView.userInteractionEnabled = NO;
        
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mineCommentView.layer.borderColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1].CGColor;
    [self initData];
    [self.commentBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    view.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    UIView *tmpView = _tableView.tableFooterView;
    tmpView.frame = CGRectMake(0, 0, ScreenW, 50);
    _tableView.tableFooterView = tmpView;
    _tableView.tableFooterView = view;
    
    
    //添加标题在头部
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 50)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 24, 50)];
    label.text = self.article.title;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentNatural;
    label.numberOfLines = 0;
    [self.titleView addSubview:label];
    [self.view addSubview:self.titleView];
    self.titleView.hidden = YES;

}



//展示评论视图
-(void)showCommentView{
    self.bottomView.hidden = NO;
    self.topView.hidden = NO;
    [self.comentTextView becomeFirstResponder];
    
}
//取消评论
- (IBAction)cancelComentAction:(id)sender {
    self.bottomView.hidden = YES;
    self.topView.hidden = YES;
    [self.comentTextView resignFirstResponder];
    
}
//发表评论
- (IBAction)publishComentAction:(id)sender {
    [self.comentTextView resignFirstResponder];

    if (self.comentTextView.text.length > 0) {
        NSDictionary *dict= @{@"id":[NSString stringWithFormat:@"%ld",self.article.id],@"content":self.comentTextView.text};
        NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
        result.onSuccess = ^(id responseObject) {
            [NTGMBProgressHUD alertView:@"评论成功" view:self.view];
            self.bottomView.hidden = YES;
            self.topView.hidden = YES;
            self.comentTextView.text = nil;
            [self getCommentsData];

        };
        [NTGSendRequest publishComment:dict success:result];

    }else{
    
     [NTGMBProgressHUD alertView:@"内容不能为空" view:self.view];
    
    }
}



-(void)setCommentArray:(NSMutableArray *)commentArray
{
    if (_commentArray != commentArray) {
        _commentArray = commentArray;
        [self.tableView reloadData];
    }


}

-(void)setRelatedArray:(NSMutableArray *)relatedArray{

    _relatedArray = relatedArray;
    [self.tableView reloadData];

}
-(void)setStrHtml:(NSString *)strHtml
{
    _strHtml = strHtml;
    NSString *BookStr = [NSString stringWithFormat:@"<html> \n"
                         "<head> \n"
                         "<style type=\"text/css\"> \n"
                         "* {font-size:%d!important;}\n"
                         "</style> \n"
                         "</head> \n"
                         "<body>%@</body> \n"
                         "</html>",18,self.strHtml];
//    NSString * formatString = @"<span style=\"font-size:13px;color:#F5F5F5\">%@</span>";
//    NSString * htmlString = [NSString stringWithFormat:formatString,self.strHtml];
    [self.webView loadHTMLString:BookStr baseURL:nil];
    
}
-(void)setArticleDetail:(NTGArticle *)articleDetail{
    _articleDetail = articleDetail;
    //结果得到后才能进行判断，否则直接跳过无法获取任何值
    [self judgePriseAndSave];
    [self.tableView reloadData];
}
-(void)initData{

    self.commentArray = [NSMutableArray new];
    //文章详情
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGArticle *atrticle){
        self.articleDetail = atrticle;
        self.strHtml = atrticle.realContent;
        
    };
    [NTGSendRequest getArticleDetail:self.article.path success:result];
    
    [self getRelatedData];

    //评论列表
    [self getCommentsData];
    
    //判断是否收藏和是否点赞
}

//判断是否收藏和是否点赞 6214 8301 5694 2731
-(void)judgePriseAndSave{
  
    //判断时候已点赞
    NSString *str = [_articleDetail.isPraise stringValue];
    if ([str isEqualToString:@"1"]) {
        self.shareBtn.selected = YES;
    }else{
        self.shareBtn.selected = NO;
    }
    
    //判断是否已收藏
    NSString *string = [_articleDetail.isFavorite stringValue];
    if ([string isEqualToString:@"1"]) {
        self.saveBtn.selected = YES;
    }else{
        self.saveBtn.selected = NO;
    }
}

-(void)getCommentsData{
    
    //评论列表
    NSDictionary *dict = @{@"id":[NSString stringWithFormat:@"%ld",self.article.id],@"pageNumber":@"1",@"pageSize":@"5"};
    
    NTGBusinessResult *commentResult = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    commentResult.onSuccess = ^(NTGPage *page){
        
        self.commentArray = [NSMutableArray arrayWithArray:page.content];
    };
    [NTGSendRequest getArticleComment:dict success:commentResult];
    


}

-(void)getRelatedData{
    _relatedArray = [NSMutableArray new];
    if (_article.articleTag != nil) {
        //相关新闻列别
        NSDictionary *dict2 = @{@"articleTag":_article.articleTag,
                                @"articleId":[NSString stringWithFormat:@"%ld",self.article.id]
                                };
        NTGBusinessResult *relatedReult = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
        relatedReult.onSuccess = ^(NSArray *page){
            
            self.relatedArray = [NSMutableArray arrayWithArray:page];
            for (NTGArticle *item in page) {
                NSLog(@"%@  %@   %@    %@",item.image,item.articleSourceName,item.articleTag,item.displayTime);
            }
        };
        [NTGSendRequest getArticleRelated:dict2 success:relatedReult];
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
        _hud= nil;
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self addHudWithMessage:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeHud];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var script = document.createElement('script');"
                                                     "script.type = 'text/javascript';"
                                                     "script.text = \"function ResizeImages() { "
                                                     "var myimg,oldwidth;"
                                                     "var maxwidth = %f;" // UIWebView中显示的图片宽度
                                                     "var maxheight = maxwidth*9/16.0;"
                                                     "for(i=0;i <document.images.length;i++){"
                                                     "myimg = document.images[i];"
                                                     "if(myimg.width > maxwidth){"
                                                     "oldwidth = myimg.width;"
                                                     "myimg.width = maxwidth;"
                                                     "myimg.height = maxheight;"
                                                     
                                                     "}"
                                                     "}"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);",kScreenWidth - 30]];
    //文本的对齐方式
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.textAlign = 'justify';"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];    //页面背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#F5F5F5'"];
    //字体大小
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];//修改百分比即可
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('img')[%d].style.width = '100%'"];
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];

    self.webView.height = height + 10;
    [self.tableView reloadData];
    
}

#pragma mark - tableView的代理方法
//这个方法是为了不让分区的头部视图悬停
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 67;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    NSLog(@"%f",self.tableView.contentOffset.y);
    if (self.tableView.contentOffset.y > 44) {
        self.titleView.hidden = NO;
    }else if(self.tableView.contentOffset.y <= 44){
        self.titleView.hidden = YES;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenW -30, CGFLOAT_MIN)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [view addSubview:self.webView];
         return view;
    }else if (section == 3){
        //这里不使用xib里的cell是因为XIB自身的原因导致使用后会导致header和cell之间有一条白线
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 37)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        UIView *flagView = [[UIView alloc] initWithFrame:CGRectMake(12, 10, 4, 18)];
        flagView.backgroundColor = [UIColor colorWithRed:0 green:104/255.0 blue:183/255.0 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, 10, 65.5, 20)];
        label.text = @"相关新闻";
        label.textColor = [UIColor colorWithRed:0 green:104/255.0 blue:183/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:16];
        [view addSubview:flagView];
        [view addSubview:label];
        
       // NTGNewsDetailCell *cell = [NTGNewsDetailCell theSectionHeaderCell];
        return view;
    
    }else if (section == 4){
        NTGNewsDetailCell *cell = [NTGNewsDetailCell theCommentHeaderCell];
        
        return cell;
    
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.webView.height;
    }else if (section == 3){
        return 37;
    
    }else if (section == 4){
        return 67;
    }
    return CGFLOAT_MIN;



}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return self.relatedArray.count > 0 ? self.relatedArray.count : 1;
            break;

        case 4:
            return self.commentArray.count > 0 ? self.commentArray.count : 1;
            break;

            
        default:
            break;
    }
    return 1;

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 125;
    }else if(indexPath.section == 1){
        return CGFLOAT_MIN;
    }else if (indexPath.section == 2){
    
        CGFloat shareH = (750 - 220 -164) / 3.0;
//        return 133 + ScreenW * shareH / 750.0  + 27;
        return [self checkWechatAndWeiboApp] ? 133 + ScreenW * shareH / 750.0  + 27:0;
//        return 0;

    }else if (indexPath.section == 4){
        if (self.commentArray.count > 0) {
            NTGArticleComment *comment = self.commentArray[indexPath.row];
            return [comment commentCellHeight];
        }
        return 120;

    }       
    return 88;
    
}
-(void)weixinShareAction:(UIButton *)sender{
    [LLShareSDKTool initialize];
    //1. 创建分享参数
    NSURL *url = [NSURL URLWithString:self.article.image];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *img;
    
    if (url) {
        if ([manager diskImageExistsForURL:url])
        {
            img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            
        }
        else
        {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
        }
        
    }else{
        img = [UIImage imageNamed:@"index_backImg"];
        
    }

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare]; //这个参数控制是"应用内分享(网页分享)" 还是客户端分享. 不加的话是'应用内分享(网页分享)'
    
    [shareParams SSDKSetupShareParamsByText:self.article.paper
                                     images:img
                                        url:[NSURL URLWithString:self.articleDetail.sharePath]
                                      title:self.articleDetail.title
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                NSString *errorStr = @"抱歉，需要安装微信客户端才能分享！";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:errorStr
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
        
    }];

    

}

-(void)pengyouquanShareAction:(UIButton *)sender{
    [LLShareSDKTool initialize];
    //1. 创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSURL *url = [NSURL URLWithString:self.article.image];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *img;
    
    if (url) {
        if ([manager diskImageExistsForURL:url])
        {
            img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            
        }
        else
        {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
        }
        
    }else{
        img = [UIImage imageNamed:@"index_backImg"];
        
    }

    [shareParams SSDKEnableUseClientShare]; //这个参数控制是"应用内分享(网页分享)" 还是客户端分享. 不加的话是'应用内分享(网页分享)'
    
    [shareParams SSDKSetupShareParamsByText:self.article.paper
                                     images:img
                                        url:[NSURL URLWithString:self.articleDetail.sharePath]
                                      title:self.articleDetail.title
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                NSString *errorStr = @"抱歉，需要安装微信客户端才能分享！";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:errorStr
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
        
    }];
}
-(void)weiboShareAction:(UIButton *)button{
    [ShareSDK initialize];
    //1. 创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSURL *url = [NSURL URLWithString:self.article.image];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *img;
    
    if (url) {
        if ([manager diskImageExistsForURL:url])
        {
            img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            
        }
        else
        {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
        }
        
    }else{
        img = [UIImage imageNamed:@"index_backImg"];
        
    }
    
    [shareParams SSDKEnableUseClientShare]; //这个参数控制是"应用内分享(网页分享)" 还是客户端分享. 不加的话是'应用内分享(网页分享)'
    if (self.article.paper.length > 100) {
        self.article.paper = [self.article.paper substringWithRange:NSMakeRange(0, 100)];
    }

    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",self.article.paper,self.article.sharePath]
                                     images:img
                                        url:[NSURL URLWithString:self.articleDetail.sharePath]
                                      title:self.articleDetail.title
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                NSString *errorStr = @"抱歉，需要安装微博客户端才能分享！";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:errorStr
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:
                break;
        }
    
    }];
    
    
    
    
    
   // [NTGMBProgressHUD alertView:@"抱歉，暂时无法分享" view:self.view];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NTGNewsDetailCell *cell = [NTGNewsDetailCell theTitleCell];
        cell.article = self.article;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if( indexPath.section == 1 ){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
    
    }else if (indexPath.section == 2){
        BOOL isInstallApp = [self checkWechatAndWeiboApp];
        if(isInstallApp){
            // NTGNewsDetailCell *cell = [NTGNewsDetailCell theShareCell];
            NTGNewsDetailShareCell *cell = [NTGNewsDetailShareCell theShareCellWithTableView:tableView];
            [cell.weiXinShareBtn addTarget:self action:@selector(weixinShareAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.pengyouquanShareBtn addTarget:self action:@selector(pengyouquanShareAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.weiboShareBtn addTarget:self action:@selector(weiboShareAction:) forControlEvents:UIControlEventTouchUpInside];
            // cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if(indexPath.section == 3){
        if (self.relatedArray.count > 0) {
            
            NTGGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"NTGGeneralCell" owner:nil options:nil]lastObject];;
            }
            NTGArticle *article = self.relatedArray[indexPath.row];
            cell.article = article;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xcell" ];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xcell"];
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
            label.text = @"没有相关新闻~";
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            cell.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
        

    }else{
        if (self.commentArray.count > 0) {
            NTGCommentCell *cell = [NTGCommentCell theCommentCellWithTableView:self.tableView];
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Bcell" ];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Bcell"];
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
            label.text = @"还没有评论，赶快去评论一下吧~";
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            cell.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        if (self.relatedArray.count > 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil];
            NTGNewsDetailController *generalVC = [storyboard instantiateInitialViewController];
            NTGArticle *article = self.relatedArray[indexPath.row];
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
        
    }


}
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showComment"]) {
        NTGCommentsController *controller = segue.destinationViewController;
        controller.articleId = [NSString stringWithFormat:@"%ld",self.article.id];
    }


}
//


#pragma mark-------检测是否安装了微信和微博

-(BOOL)checkWechatAndWeiboApp{
    
    if ([WXApi isWXAppInstalled] && [WeiboSDK isWeiboAppInstalled]) {
        return YES;
    }
    return NO;


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
