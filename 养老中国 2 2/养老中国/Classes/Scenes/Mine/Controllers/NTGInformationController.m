/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGInformationController.h"
#import "UIImage+ScreenShot.h"
#import "NTGProfiles.h"

/**
 * control - 个人资料
 *
 * @author nbcyl Team
 * @version 3.0
 */
@interface NTGInformationController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**个人头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
/**个人头像Btn*/
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
/**姓名*/
@property (weak, nonatomic) IBOutlet UITextField *userName;
/**电话*/
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
/**性别 - 男*/
@property (weak, nonatomic) IBOutlet UIButton *sexMBtn;
/**性别 - 女*/
@property (weak, nonatomic) IBOutlet UIButton *sexWBtn;
/**性别*/
@property (nonatomic,strong) NSString *sex;

@property (nonatomic,strong) NTGProfiles *profile;

@property (nonatomic,strong) NSMutableDictionary *reqParam;

@property (weak, nonatomic) IBOutlet UIView *phoneBackView;

@end

@implementation NTGInformationController
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
    [self getMemberInformation];
}

-(void)iconImgChange{
    NSString *iconImg = [[NSUserDefaults standardUserDefaults] valueForKey:@"iconImg"];
    
    [[SDImageCache sharedImageCache] removeImageForKey:iconImg];//由于SDWebImage的缓存机制，优先使用缓存已经缓存的图片，如果进行更改则先移除之前的
}

//更新用户资料
- (IBAction)updateProfileAction:(id)sender {
    _reqParam = [NSMutableDictionary new];
    if (_userName.text.length > 0 ) {
        NSDictionary *dict = @{@"petName":_userName.text};
        NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController removePreCtrol:YES];
        result.onSuccess = ^(id object){
            if ([object intValue] == 0) {
                [NTGMBProgressHUD alertView:@"这个昵称已被使用" view:self.view];
            }else{
                
                if (_sexMBtn.selected) {
                    [_reqParam setValue:@"male" forKey:@"gender"];
                    [self requestUpdate];
                }else if(_sexWBtn.selected){
                    [_reqParam setValue:@"female" forKey:@"gender"];
                    [self requestUpdate];
                }else{
                    [NTGMBProgressHUD alertView:@"性别不能为空" view:self.view];
                }
            
            }
        };
        result.onFail = ^(id object){
            NSString *desc = (NSString *)object;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:desc preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
             //[NTGMBProgressHUD alertView:@"请输入正确昵称，建议4-20字符，支持汉字、字母、数字，且不能纯数字" view:self.view];
        };
        
        [NTGSendRequest checkPetName:dict success:result];
        [_reqParam setObject:_userName.text forKey:@"petName"];
    }else{
        [NTGMBProgressHUD alertView:@"昵称不能为空" view:self.view];
    }
    
    [_userName resignFirstResponder];
    
}

-(void)requestUpdate{

    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController];
    result.onSuccess = ^(id object){
        //记录用户头像地址
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_userName.text forKey:@"petName"];
        [userDefaults synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    result.onFail = ^(id object){
        NSString *desc = (NSString *)object;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:desc preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    [NTGSendRequest getUpdateMember:_reqParam success:result];
}

//获取个人资料
-(void)getMemberInformation{
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController removePreCtrol:YES];
    result.onSuccess = ^(NTGProfiles *profile){
        [self iconImgChange];
        [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:profile.picture]];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if([userDefault boolForKey:@"isThird"]){
            self.phoneBackView.hidden = YES;

        }else{
            self.phoneNum.text = profile.mobile;
        
        }
        self.userName.text = profile.petName;
        if ([profile.gender isEqualToString:@"male"]) {
            self.sexMBtn.selected = YES;
        }
        if ([profile.gender isEqualToString:@"female"]) {
            self.sexWBtn.selected = YES;
        }
        _profile = profile;
        //记录用户头像地址
//        //创建一个消息对象
//        NSNotification * notice = [NSNotification notificationWithName:@"tongzhi" object:self userInfo:@{@"iconImg":_profile.picture}];
//        //发送消息
//        [[NSNotificationCenter defaultCenter] postNotification:notice];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:profile.picture forKey:@"iconImg"];
        [userDefaults synchronize];
    
    };
    [NTGSendRequest getMyProfile:nil multipartFormData:nil success:result];
    



}


- (IBAction)choosePictureAction:(id)sender {
//    UIAlertView *alertChoose = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"本地图库",nil];
//    alertChoose.tag = 1000;
//    [alertChoose show];
    
    //在这里呼出下方菜单按钮项
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"从本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LocalPhoto];
    }];
    UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:cancelAction1];
    [alertController addAction:cancelAction2];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        // [picker release];
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

/** 选中照片 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    UIImagePickerControllerOriginalImage 原始图片
    //    UIImagePickerControllerEditedImage 编辑后图片
    //self.iconView.image = nil;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    size_t size = sizeof(image);
    
    CGSize imagesize = image.size;
//    imagesize.height =250;
//    imagesize.width =250;
    imagesize.height = 250;
    imagesize.width = 250;

    //对图片大小进行压缩--
    image = [image imageByScalingAndCroppingForSize:imagesize];
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 0.1);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    NSDictionary *parameters = @{
                                 @"id":[NSString stringWithFormat:@"%ld",_profile.id]
                                 };
    
    NSDictionary *multipartFormDataDict = @{
                                            @"file":filePath
                                            };
    NTGBusinessResult *result = [[NTGBusinessResult alloc] initWithNavController:self.navigationController removePreCtrol:NO];
    result.onSuccess = ^(NSString *operate) {
        self.iconImgV.image = image;
        self.iconChange(YES);
    };
    result.onFail = ^(id object){
        NSString *desc = (NSString *)object;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:desc preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        //[NTGMBProgressHUD alertView:@"请输入正确昵称，建议4-20字符，支持汉字、字母、数字，且不能纯数字" view:self.view];
    };
    [NTGSendRequest getUpdateMemberHead:parameters multipartFormData:multipartFormDataDict success:result];
    
       [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}

/** 取消相册 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//选择女
- (IBAction)chooseWomenAction:(id)sender {
    self.sexWBtn.selected = YES;
    self.sexMBtn.selected = NO;
    self.sex = @"女";
}
//选择男
- (IBAction)chooseManAction:(id)sender {
    self.sexWBtn.selected = NO;
    self.sexMBtn.selected = YES;
    self.sex = @"男";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
