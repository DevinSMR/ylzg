/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGFindPasswordController.h"
#import "CocoaSecurity.h"
#import "NTGValidateMobile.h"


@interface NTGFindPasswordController ()
/*用户手机号**/
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
/*发送短信按钮**/
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
/*用户验证码**/
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
/*用户新密码**/
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTF;
/*确认密码**/
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;

@property (nonatomic,copy) NSString *validCodeKey;


@end

@implementation NTGFindPasswordController
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
    
}

//发送验证码
- (IBAction)sendSeccodeAction:(id)sender {
    [self startTime];
}

/** 获取验证码 */
- (void)startTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_sendBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                _sendBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            if (seconds == 0) {
                seconds = 60;
            }
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_sendBtn setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _sendBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    NSDictionary *repram;
    if (self.phoneTF.text) {
        repram = @{@"mobile":self.phoneTF.text};
    }
    if (![NTGValidateMobile validateMobile:self.phoneTF.text]) {
        
        [NTGMBProgressHUD alertView:@"请输入正确的手机号" view:self.view];
    }else {
        
                NTGBusinessResult *results = [[NTGBusinessResult alloc] initWithNavController:self.navigationController removePreCtrol:YES];
                NSDictionary *dict;
                
                dispatch_resume(_timer);
                //                if (self.member) {
                //                    dict = @{@"mobile":self.member.mobile};
                //                }else {
                //                    dict = @{@"mobile":self.phoneNum.text};
                //                }
                dict = @{@"mobile":self.phoneTF.text};
                results.onSuccess = ^(id responseObject) {
                    self.validCodeKey = responseObject;
                    [NTGMBProgressHUD alertView:@"验证码已经发送" view:self.view];
                };
                [NTGSendRequest getSMSValidCode:dict success:results];
                
            }
    
}

/*点击完成**/
- (IBAction)finishAction:(id)sender {
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController removePreCtrol:YES];
    if (![self.passwordNewTF.text isEqualToString:self.confirmPasswordTF.text]) {
        [NTGMBProgressHUD alertView:@"确认密码与新密码不一致" view:self.view];
        return;
    }
    if ([self checkFinish]) {
        NSDictionary  *dicts = @{
                                 @"enPassword":self.passwordNewTF.text,
                                 @"validCodeKey":self.validCodeKey,
                                 @"validCodeValue":self.passwordTF.text,
                                 @"mobile":self.phoneTF.text
                                 };
        [NTGSendRequest getUpdatePassword:dicts success:result];
        result.onSuccess = ^(id responseObject) {
            [NTGMBProgressHUD alertView:@"密码修改成功！" view:self.view];
            //短暂延迟后返回到登录页面
            double delayInSeconds = 1.3;
            // __block NTGFindPasswordController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES]; });
            //[self.navigationController popViewControllerAnimated:YES];
        };
        result.onFail = ^(id object){
            NSString *desc = (NSString *)object;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:desc preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            //[NTGMBProgressHUD alertView:@"请输入正确昵称，建议4-20字符，支持汉字、字母、数字，且不能纯数字" view:self.view];
        };

    }

}


- (BOOL)checkFinish {
    BOOL finish = YES;
    if (
        self.phoneTF.text.length==0 ||
        self.passwordNewTF.text.length==0 ||
        self.validCodeKey.length==0 ||
        self.passwordTF.text.length==0
        ) {
        [NTGMBProgressHUD alertView:@"亲，资料不完整哦!" view:self.view];
        return NO;
    }
    return finish;
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
