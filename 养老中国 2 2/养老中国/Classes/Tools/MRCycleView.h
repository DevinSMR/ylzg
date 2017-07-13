

#import <UIKit/UIKit.h>

@interface MRCycleView : UIView
//数组
@property (nonatomic,strong) NSMutableArray *imgNameArray;
//初始化方法
-(instancetype) initWithFrame:(CGRect)frame Intervar:(NSTimeInterval)interval;
//添加block回调
-(void)addTapBlock:(void(^)(NSInteger index))block;
@end
