/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGMineController.h"
#import "NTGMember.h"
#import "NTGInformationController.h"
#import "NTGLoginController.h"
#import "NTGProfiles.h"
#import "NTGFavoiteController.h"
#import "NTGCommetController.h"
#import <ShareSDK/ShareSDK.h>

@interface NTGMineController ()<UIScrollViewDelegate>
/*用户头像**/
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
/*登录按钮**/
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/*退出登录按钮**/
@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;

@property (weak, nonatomic) IBOutlet UILabel *cashing;
//用户昵称按钮
@property (weak, nonatomic) IBOutlet UIButton *petNameBtn;

//底层视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation NTGMineController
- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    

    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin) {
        NSString *petName = [[NSUserDefaults standardUserDefaults] objectForKey:@"petName"];
        if (petName) {
//            [_loginBtn setTitle:petName forState:UIControlStateNormal];
//             _loginBtn.enabled = NO;
            _petNameBtn.hidden = NO;
            _loginBtn.hidden = YES;
            [_petNameBtn setTitle:petName forState:UIControlStateNormal];
            _loginOutBtn.hidden = NO;
            
            NSString *iconImg = [userDefaults valueForKey:@"iconImg"];
            if (iconImg == nil) {
                _userIcon.image = [UIImage imageNamed:@"mine"];
            }else{
                
                [self.userIcon sd_setImageWithURL:[NSURL URLWithString:iconImg] placeholderImage:[UIImage imageNamed:@"mine"]];
            }
         }else{
            [_loginBtn  setTitle:@"立即登录" forState:UIControlStateNormal];
            _loginBtn.enabled = YES;
            _userIcon.image = [UIImage imageNamed:@"mine"];
        
        }
    }else{
        _petNameBtn.hidden = YES;
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        _loginBtn.enabled = YES;
        _loginOutBtn.hidden = YES;
        _userIcon.image = [UIImage imageNamed:@"mine"];
    }
    
    self.cashing.text = [[NSString stringWithFormat:@"%.1f",[self filePath]] stringByAppendingString:@"M"];
    

}

-(void)iconImgChange{
    NSString *iconImg = [[NSUserDefaults standardUserDefaults] valueForKey:@"iconImg"];

    [[SDImageCache sharedImageCache] removeImageForKey:iconImg];//由于SDWebImage的缓存机制，优先使用缓存已经缓存的图片，如果进行更改则先移除之前的
}
- (void)viewDidLoad {
    [super viewDidLoad];
   // [self initdata];
   // [_loginBtn setTitle:@"我们" forState:UIControlStateNormal];
    self.scrollView.delegate = self;

}

//跳转到我的资料
- (IBAction)pushToInformationAction:(id)sender {
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(initdata) object:[NSNumber numberWithBool:YES]];
//    [self performSelector:@selector(initdata) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5];
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        NTGInformationController  *information = [storyboard instantiateViewControllerWithIdentifier:@"information"];
        
        //当个人资料里的头像发生改变时，需要移除之前缓存的头像
            __weak typeof (self)weakSelf = self;
        information.iconChange = ^(BOOL isChange){
            [weakSelf iconImgChange];
        };
        [self.navigationController pushViewController:information animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        NTGLoginController  *information = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController pushViewController:information animated:YES];
    }
}
//获取个人信息
-(void) initdata{
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGProfiles *profile){
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:profile.picture]];
    };
    [NTGSendRequest getMyProfile:nil multipartFormData:nil success:result];



}

//清除缓存
- (IBAction)cleanCashAction:(id)sender {
    [self clearFile];
}

// 显示缓存大小
- (float)filePath {
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [self folderSizeAtPath:cachPath];
}

//1:首先我们计算一下 单个文件的大小

- (long long)fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}

//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- (float)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
    
}

// 清理缓存
- (void)clearFile {
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    //    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone: YES ];
}

-(void)clearCachSuccess {
    self.cashing.text = [[NSString stringWithFormat:@"%.1f",[self filePath]] stringByAppendingString:@"M"];
    [NTGMBProgressHUD alertView:@"清理成功" view:self.view];
}

//跳转到我的评论页面
- (IBAction)toMyCommentPageAction:(id)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        NTGCommetController  *commentVC = [storyboard instantiateViewControllerWithIdentifier:@"comment"];
        [self.navigationController pushViewController:commentVC animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        NTGLoginController  *information = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController pushViewController:information animated:YES];
    }
}
//跳转到我的收藏页面
- (IBAction)toMyFavoiterPageAction:(id)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if (isLogin) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        NTGFavoiteController  *favoriteVC = [storyboard instantiateViewControllerWithIdentifier:@"favorite"];
        [self.navigationController pushViewController:favoriteVC animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        NTGLoginController  *information = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController pushViewController:information animated:YES];
    }
}


//退出登录
- (IBAction)logoOutAction:(id)sender {
    [self logOut];
}

-(void)logOut{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定退出登录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
        result.onSuccess = ^(NTGProfiles *profile){
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            NSString *iconImg = [[NSUserDefaults standardUserDefaults] valueForKey:@"iconImg"];
            [[SDImageCache sharedImageCache] removeImageForKey:iconImg];        _userIcon.image = [UIImage imageNamed:@"mine"];
            [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
            _loginBtn.hidden = NO;
            _petNameBtn.hidden = YES;
            _loginOutBtn.hidden = YES;
            _loginBtn.enabled = YES;
            
            [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
            [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
            [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:NO forKey:@"isThird"];
        };
        [NTGSendRequest loginOut:nil success:result];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:cancelAction1];
    
    [self presentViewController:alertController animated:YES completion:nil];


}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    




}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
