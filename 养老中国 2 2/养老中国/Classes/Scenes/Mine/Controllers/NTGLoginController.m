/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGLoginController.h"
#import "NTGMBProgressHUD.h"
#import "NTGNetworkTool.h"
#import "NTGSendRequest.h"
#import <Base64.h>
#import "CocoaSecurity.h"
#import "RSA.h"
#import "NTGMember.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

/**
 * control - 登录
 *
 * @author nbcyl Team
 * @version 3.0
 */



@interface NTGLoginController ()
/**用户手机号*/
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
/**用户密码*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
/**登录*/
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@end

@implementation NTGLoginController
- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    /**注册监听*/
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:self.phoneNumberTF];
    [center addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:self.passwordTF];
    self.loginBtn.layer.borderColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1].CGColor;
    self.forgetPasswordBtn.layer.borderColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1].CGColor;
    
    [self.phoneNumberTF setValue:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTF setValue:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
}
/** 监听文本框文字改变 */
- (void)textChanged {
    self.loginBtn.enabled = (self.phoneNumberTF.text.length > 0 && self.passwordTF.text.length > 0);
}

/** 移除通知 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    [NTGSendRequest getPublicKey:nil success:^(id responseObject) {
        NSString *username = self.phoneNumberTF.text;
        NSString *password = self.passwordTF.text;
        CocoaSecurityResult * securityEnPassword = [CocoaSecurity md5:password];
        NSString * md5Hex = securityEnPassword.hexLower;
        NSDictionary * dict = @{@"username":username, @"enPassword":md5Hex};
        
        NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
        result.onSuccess = ^(NTGMember * member) {
            //            self.member = member;
            //            登陆成功后把用户名和密码存储到UserDefault
            [userDefaults setObject:username forKey:@"name"];
            [userDefaults setObject:password forKey:@"password"];
           // BOOL islogin = YES;
            [userDefaults setBool:YES forKey:@"isLogin"];
            [userDefaults setObject:[NSString stringWithFormat:@"%ld",member.userid ] forKey:@"userID"];
            [userDefaults setObject:member.petName forKey:@"petName"];
            [userDefaults setObject:member.pictureSml forKey:@"iconImg"];
            [userDefaults setBool:NO forKey:@"isThird"];

            [userDefaults synchronize];//这条语句是数据及时写入的意思
        
            [self.navigationController popViewControllerAnimated:YES];
        };
        result.onFail = ^(id responseObject){
            [NTGMBProgressHUD alertView:@"对不起，您的用户名或密码错误！" view:self.view];
        };
        [NTGSendRequest login:dict success:result];
    }];
 
    
}

- (IBAction)QQLoginAction:(id)sender {
    
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSString *icon = [user.rawData objectForKey:@"figureurl_qq_2"];
             NSDictionary *dict = @{@"userToken":user.credential.token,
                                    @"userId":[NSString stringWithFormat:@"QQ_%@",user.uid],
                                    @"userName":user.nickname,
                                    @"userImgUrl":icon,
                                    @"userGender":[NSString stringWithFormat:@"%ld",user.gender]};
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

             NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
             result.onSuccess = ^(NTGMember *member) {
                 //            登陆成功后把用户名和密码存储到UserDefault
                 // BOOL islogin = YES;
                 NSLog(@"%@",member);
                 [userDefaults setBool:YES forKey:@"isLogin"];
                 [userDefaults setObject:[NSString stringWithFormat:@"%ld",member.userid] forKey:@"userID"];
                 [userDefaults setObject:member.petName forKey:@"petName"];
                 [userDefaults setObject:member.pictureSml forKey:@"iconImg"];
                 [userDefaults setBool:YES forKey:@"isThird"];
                 [userDefaults synchronize];//这条语句是数据及时写入的意思
                 
                 [self.navigationController popViewControllerAnimated:YES];
             };
             result.onFail = ^(id responseObject){
                 [NTGMBProgressHUD alertView:@"对不起，您的用户名或密码错误！" view:self.view];
             };
             [NTGSendRequest thirdPartylogin:dict success:result];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];}

- (IBAction)weiboLogin:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSDictionary *dict = @{@"userToken":user.credential.token,
                                    @"userId":[NSString stringWithFormat:@"SinaWeibo_%@",user.uid],
                                    @"userName":user.nickname,
                                    @"userImgUrl":user.icon,
                                    @"userGender":[NSString stringWithFormat:@"%ld",user.gender]};
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             
             NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
             result.onSuccess = ^(NTGMember *member) {
                 //            登陆成功后把用户名和密码存储到UserDefault
                 // BOOL islogin = YES;
                 [userDefaults setBool:YES forKey:@"isLogin"];
                 [userDefaults setObject:[NSString stringWithFormat:@"%ld",member.userid] forKey:@"userID"];
                 [userDefaults setObject:member.petName forKey:@"petName"];
                 [userDefaults setObject:member.pictureSml forKey:@"iconImg"];
                 [userDefaults setBool:YES forKey:@"isThird"];
                 [userDefaults synchronize];//这条语句是数据及时写入的意思
                 
                 [self.navigationController popViewControllerAnimated:YES];
             };
             result.onFail = ^(id responseObject){
                 [NTGMBProgressHUD alertView:@"对不起，您的用户名或密码错误！" view:self.view];
             };
             [NTGSendRequest thirdPartylogin:dict success:result];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];

}
- (IBAction)weixinLogin:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSDictionary *dict = @{@"userToken":user.credential.token,
                                    @"userId":[NSString stringWithFormat:@"Wechat_%@",user.uid],
                                    @"userName":user.nickname,
                                    @"userImgUrl":user.icon,
                                    @"userGender":[NSString stringWithFormat:@"%ld",user.gender]};
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             
             NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
             result.onSuccess = ^(NTGMember *member) {
                 //            登陆成功后把用户名和密码存储到UserDefault
                 // BOOL islogin = YES;
                 [userDefaults setBool:YES forKey:@"isLogin"];
                 [userDefaults setObject:[NSString stringWithFormat:@"%ld",member.userid] forKey:@"userID"];
                 [userDefaults setObject:member.petName forKey:@"petName"];
                 [userDefaults setObject:member.pictureSml forKey:@"iconImg"];
                 [userDefaults setBool:YES forKey:@"isThird"];
                 [userDefaults synchronize];//这条语句是数据及时写入的意思
                 
                 [self.navigationController popViewControllerAnimated:YES];
             };
             result.onFail = ^(id responseObject){
                 [NTGMBProgressHUD alertView:@"对不起，您的用户名或密码错误！" view:self.view];
             };
             [NTGSendRequest thirdPartylogin:dict success:result];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];

}

-(void)loginThird:(SSDKUser *)user{
    NSString *icon = [user.rawData objectForKey:@"figureurl_qq_2"];
    NSDictionary *dict = @{@"userToken":user.credential.token,
                           @"userId":user.uid,
                           @"userName":user.nickname,
                           @"userImgUrl":icon,
                           @"userGender":[NSString stringWithFormat:@"%ld",user.gender]};
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(NTGMember *member) {
        //            登陆成功后把用户名和密码存储到UserDefault
        // BOOL islogin = YES;
        [userDefaults setBool:YES forKey:@"isLogin"];
        [userDefaults setObject:[NSString stringWithFormat:@"%ld",member.userid] forKey:@"userID"];
        [userDefaults setObject:member.petName forKey:@"petName"];
        [userDefaults setObject:member.pictureSml forKey:@"iconImg"];
        [userDefaults setBool:YES forKey:@"isThird"];
        [userDefaults synchronize];//这条语句是数据及时写入的意思
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    result.onFail = ^(id responseObject){
        [NTGMBProgressHUD alertView:@"对不起，您的用户名或密码错误！" view:self.view];
    };
    [NTGSendRequest thirdPartylogin:dict success:result];
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
