/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGAboutUsController.h"
/**
 * control - 关于我们
 *
 * @author nbcyl Team
 * @version 3.0
 */
@interface NTGAboutUsController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NTGAboutUsController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (IBAction)backToAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTextViewAttributes{
    //NSString *str = @"";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    _textView.attributedText = [[NSAttributedString alloc] initWithString:_textView.text attributes:attributes];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTextViewAttributes];

    
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
