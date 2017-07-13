
//
//  NTGWebVideoController.m
//  养老中国
//
//  Created by nbc on 16/10/31.
//  Copyright © 2016年 DevinCoder. All rights reserved.
//

#import "NTGWebVideoController.h"

@interface NTGWebVideoController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
//加载页面中
@property (nonatomic,retain) MBProgressHUD* hud;

@end

@implementation NTGWebVideoController


- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self addHudWithMessage:@"加载中"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeHud];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.article.links]]];
    _webView.delegate = self;
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
