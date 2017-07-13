/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGPictureDetailController.h"
#import <UIImageView+WebCache.h>
#import "NTGCommentsController.h"
#import <ShareSDK/ShareSDK.h>
#import "LLShareSDKTool.h"
#import "ShowImageView.h"

/**
 *  control - 图片详情
 */

@interface NTGPictureDetailController ()<UIScrollViewDelegate>
/**scrollView距离顶部的约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
/**图片容器*/
@property (weak, nonatomic) IBOutlet UIScrollView *scorllView;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**图片下标*/
@property (weak, nonatomic) IBOutlet UILabel *pictureIndexLabel;
/**图片文字说明*/
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

/**评论按钮*/
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
//是否显示文字说明
@property (nonatomic,assign) BOOL *isShowIntroduce;

//发表评论的底部视图
@property (weak, nonatomic) IBOutlet UIView *buttomView;

//评论输入框
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

//点赞
@property (weak, nonatomic) IBOutlet UIButton *priseBtn;

//收藏
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


//文章详情
@property (nonatomic,strong) NTGArticle *articleDetail;

//imageView数组
@property (nonatomic,strong) NSMutableArray *imgViewArray;
//存放图片的数组
@property (nonatomic,strong) NSMutableArray *imgArray;
//当前展示图片的下标
@property (nonatomic,assign) NSInteger index;

//图片浏览
@property (nonatomic,strong) ShowImageView *pictureView;
@end

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
@implementation NTGPictureDetailController
- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self initData];
}

-(void)setArticleDetail:(NTGArticle *)articleDetail{
    _articleDetail = articleDetail;
    //结果得到后才能进行判断，否则直接跳过无法获取任何值
    [self judgePriseAndSave];
}

-(void)initData{
    
    //文章详情
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGArticle *atrticle){
        self.articleDetail = atrticle;
    };
    [NTGSendRequest getArticleDetail:self.article.path success:result];
    
}


//设置控件
-(void)setUpUI{
    self.commentBtn.layer.borderColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1].CGColor;
    //self.topConstraint.constant = ScreenH * 276 /1334.0 - 64;
   // self.topConstraint.constant = ScreenH * 276 /1334.0 - 64;
    self.scorllView.delegate = self;
    self.scorllView.pagingEnabled = YES;
    self.scorllView.bounces = NO;
   // self.scorllView.contentSize = CGSizeMake(ScreenW * self.article.articleImage.count, 0);
    self.scorllView.contentSize = CGSizeMake(ScreenW * 3, 0);
    self.contentTextView.editable = NO;
    
    
    
    self.imgViewArray = [NSMutableArray new];
    self.imgArray = [NSMutableArray new];
    NSMutableArray *picArray = [NSMutableArray new];
    
    for (NSDictionary *picDict in self.article.articleImage) {
        //self.pictureView.imageUrlArr  [NSURL URLWithString:[picDict valueForKey:@"url"]];
        [picArray addObject:[picDict valueForKey:@"url"]];
    }
    self.imgArray = picArray;
    //在scrollView上添加图片
    for (int i = 0; i < 3; i++) {
        CGFloat height = ScreenH * 564 / 1334;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ScreenW * i, 0, ScreenW, height)];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.frame = CGRectMake(0, 0, ScreenW, height);
        [view addSubview:imgView];
        [self.scorllView addSubview:view];
        [self.imgViewArray addObject:view];
        
    }
    UIView *imgView = self.imgViewArray[1];
    UIImageView *imgV = imgView.subviews[0];
    [imgV sd_setImageWithURL:[NSURL URLWithString:self.imgArray[0]]];
    self.scorllView.contentOffset = CGPointMake(ScreenW, 0);
    self.titleLabel.text = self.article.title;
    self.pictureIndexLabel.text = [NSString stringWithFormat:@"1/%ld",self.article.articleImage.count ];
    if (self.article.articleImage.count > 0) {
        NSDictionary *picDict = self.article.articleImage[0];
        if (![picDict[@"info"] isKindOfClass:[NSNull class]]) {
            self.contentTextView.text = picDict[@"info"];
        }
    }
   

}
//-(void)setImgArray:(NSMutableArray *)imgArray{
//    if (_imgArray != imgArray) {
//        _imgArray = imgArray;
//      //  NSLog(@"%@",_imgNameArray);
//        
//        //设置当前偏移量
//        [self.scorllView setContentOffset:CGPointMake(ScreenW, 0) animated:NO];
//        self.index = 1;
//        [self layoutImages];
//    }
//}
//图片滚动方法
-(void)timerAction{
    [self.scorllView setContentOffset:CGPointMake(ScreenW * 2, 0) animated:YES];
    self.index = (self.index + 1) % self.article.articleImage.count;
    
    
}
//滚动动画结束
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //回位
    [self.scorllView setContentOffset:CGPointMake(ScreenW, 0) animated:NO];
    [self layoutImages];
    
}

static CGFloat x = 0;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    x = scrollView.contentOffset.x;
    //未来执行,一直都是未来得不到执行
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (x > scrollView.contentOffset.x) {
        //向右划展示左边的图片
        [self panToleft:NO Index:self.index];
    }else if (x < scrollView.contentOffset.x){
        [self panToleft:YES Index:self.index ];
    }
        self.pictureIndexLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.index + 1,self.article.articleImage.count];

}

#pragma mark - 向左滑动,向右滑动结束切换
-(void)panToleft:(BOOL)left Index:(NSInteger)index{
    if (!left) {
        self.index = (index - 1 + self.article.articleImage.count) % self.article.articleImage.count;
    }else{
        self.index = (index + 1) % self.article.articleImage.count;
        
    }
    if (self.article.articleImage.count > 0) {
        NSDictionary *picDict = self.article.articleImage[self.index];
        if (![picDict[@"info"] isKindOfClass:[NSNull class]]) {
            self.contentTextView.text = picDict[@"info"];
        }else{
        
            self.contentTextView.text = @"";
        }
    }

    //切换图片
    [self layoutImages];
    //回位操作
    [self.scorllView setContentOffset:CGPointMake(ScreenW, 0) animated:NO];
    
}

-(void)layoutImages{
    for (int i = 0; i < 3; i++) {
        NSString *picUrl = self.imgArray[(self.index - 1 + i + self.article.articleImage.count) % self.article.articleImage.count];
        UIView *imgView = self.imgViewArray[i];
        UIImageView *imgV = imgView.subviews[0];
        [imgV sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"index_backImg"]];
    }
    
}
/**评论*/
- (IBAction)commentAction:(id)sender {
    NTGCommentsController *controller = [[UIStoryboard storyboardWithName:@"ArticleDetail" bundle:nil] instantiateViewControllerWithIdentifier:@"comment"];
    controller.articleId = [NSString stringWithFormat:@"%ld",self.article.id];
    [self.navigationController pushViewController:controller animated:YES];
    
    
}
/**我要评论*/
- (IBAction)myCommentAction:(id)sender {
    _buttomView.hidden = NO;
    [_commentTextView becomeFirstResponder];
}
/**收藏*/
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

}
/**点赞*/
- (IBAction)priseAction:(id)sender {
    NSDictionary *dict= @{@"id":[NSString stringWithFormat:@"%ld",self.article.id]};
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NSString *string) {
        if ([string isEqualToString:@"1"]) {
            _priseBtn.selected = YES;
            [NTGMBProgressHUD alertView:@"已点赞" view:self.view];
        }else{
            _priseBtn.selected = NO;
            [NTGMBProgressHUD alertView:@"已取消点赞" view:self.view];
        }
    };
    [NTGSendRequest setPraise:dict success:result];

}
/**分享*/
- (IBAction)shareAction:(id)sender {
    NSURL *url = [NSURL URLWithString:self.article.image];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *img;
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

    //Tips: LLShareContentTypeAuto类型情况下,如果分享图片的话,contentURL直接设置为nil;如果分享链接,则不设置为nil [UIImage imageNamed:@"index_backImg"]
    [LLShareSDKTool shareContentWithShareContentType:LLShareContentTypeAuto contentTitle:self.article.title contentDescription:@"养老中国 http://www.nbcyl.com" contentImage:img contentURL:self.articleDetail.sharePath showInView:self.view success:^{
        
        NSLog(@"分享成功");
    } failure:^(NSString *failureInfo) {
        
        NSLog(@"分享失败:%@",failureInfo);
        
    } OtherResponseStatus:^(SSDKResponseState state) {
        NSLog(@"分享异常类型");
    }];
    
    /**
     test1.png 1.2M 868*896 在QQ 中提示太大
     test2.png 328K 438*419 微信/微信分享只进入'SSDKResponseStateBegin'
     test3.png 117K 868*896 QQ/QQ空间 分享会提示图片太大
     test4.png 112K 200*206 微信/微信分享只进入'SSDKResponseStateBegin'
     这里涉及到平台分享规则:http://wiki.mob.com/%E5%B9%B3%E5%8F%B0%E7%89%B9%E6%AE%8A%E6%80%A7/
     */

}
/**下载*/
- (IBAction)dowloadAction:(id)sender {
    NSDictionary *picDict = self.article.articleImage[_index];

    NSURL *url = [NSURL URLWithString:picDict[@"url"]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *img;
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
    // 保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        [NTGMBProgressHUD alertView:@"未保存" view:self.view];
        
    }
    else  // No errors
    {
        [NTGMBProgressHUD alertView:@"已保存到相册" view:self.view];
    }
}
//取消评论
- (IBAction)cancelComentAction:(id)sender {
    self.buttomView.hidden = YES;
    [self.commentTextView resignFirstResponder];

}
//发表评论
- (IBAction)publishCommentAction:(id)sender {
    [self.commentTextView resignFirstResponder];
    if (self.commentTextView.text.length > 0) {
        NSDictionary *dict= @{@"id":[NSString stringWithFormat:@"%ld",self.article.id],@"content":self.commentTextView.text};
        NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
        result.onSuccess = ^(id responseObject) {
            [NTGMBProgressHUD alertView:@"评论成功" view:self.view];
            self.buttomView.hidden = YES;
            self.commentTextView.text = nil;
            
        };
        [NTGSendRequest publishComment:dict success:result];
        
    }else{
        
        [NTGMBProgressHUD alertView:@"内容不能为空" view:self.view];
        
    }

}

//判断是否收藏和是否点赞
-(void)judgePriseAndSave{
    
    //判断时候已点赞
    NSString *str = [_articleDetail.isPraise stringValue];
    if ([str isEqualToString:@"1"]) {
        self.priseBtn.selected = YES;
    }else{
        self.priseBtn.selected = NO;
    }
    
    
    //判断是否已收藏
    NSString *string = [_articleDetail.isFavorite stringValue];
    if ([string isEqualToString:@"1"]) {
        self.saveBtn.selected = YES;
    }else{
        self.saveBtn.selected = NO;
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    


}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
////    NSInteger index = scrollView.contentOffset.x / ScreenW  + 1;
////    _index = index - 1;
////    self.pictureIndexLabel.text = [NSString stringWithFormat:@"%ld/%ld",index,self.article.articleImage.count];
////    if (self.article.articleImage.count > 0) {
////        NSDictionary *picDict = self.article.articleImage[index - 1];
////        if (![picDict[@"info"] isKindOfClass:[NSNull class]]) {
////            self.contentTextView.text = picDict[@"info"];
////        }
////    }
//}


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
