//
//  NJBannerImageView.m
//  BannerViewDemo
//
//  Created by JLee Chen on 16/6/27.
//  Copyright © 2016年 JLee Chen. All rights reserved.
//

#import "NJBannerImageView.h"
#import "UIImageView+WebCache.h"
#import <sys/utsname.h>

@interface NJBannerImageView ()

@property (weak , nonatomic) UIImageView *imgV;
@property (nonatomic,strong) UIImageView *flagImgView;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation NJBannerImageView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 50)];
        imgV.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:imgV];
        _imgV = imgV;
        
        [self addTarget:self action:@selector(bannerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void) setDicProperty:(NSDictionary *)dicProperty
{
    _dicProperty = dicProperty;
    NSString *imgURL = _dicProperty[@"img"];
    if ([imgURL hasPrefix:@"http"]) {  //网络图片
        [_imgV sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"index_backImg"] options:SDWebImageRetryFailed];
       // [_imgV sd_setImageWithURL:[NSURL URLWithString:imgURL] ];
    }
    else
    {
        _imgV.image = [UIImage imageNamed:@"index_backImg"];
        
    }
    [_titleLabel removeFromSuperview];
    [_flagImgView removeFromSuperview];
    NSString *type = _dicProperty[@"type"];
    
    if ([type isEqualToString:@"image"] || [type isEqualToString:@"media"]) {
        UIImageView *flagImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 224, 18, 14)];
        flagImgV.contentMode = UIViewContentModeScaleToFill;
        //flagImgV.backgroundColor = [UIColor redColor];
        [self addSubview:flagImgV];
        _flagImgView = flagImgV;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35,221 , kScreenWidth - 90, 20)];
        //label.lineBreakMode =NSLineBreakByClipping;
        // label.backgroundColor = [UIColor greenColor];
        [self addSubview:label];
        _titleLabel = label;
        _flagImgView.image = [UIImage imageNamed:@"picture"];
    }else{
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,221 , kScreenWidth - 90, 20)];
       // label.lineBreakMode =NSLineBreakByClipping;
        [self addSubview:label];
        _titleLabel = label;

        
       
    }
    NSString *string = _dicProperty[@"title"];
    NSString *iphoneType = [self iphoneType];
    if ([iphoneType isEqualToString:@"iPhone 4S"] || [iphoneType isEqualToString:@"iPhone 5"] || [iphoneType isEqualToString:@"iPhone 5c"] || [iphoneType isEqualToString:@"iPhone 5s"] || [iphoneType isEqualToString:@"iPhone SE"]) {
        if (string.length > 14) {
            NSString *title = [_dicProperty[@"title"] substringWithRange:NSMakeRange(0, 13)];
            
            _titleLabel.text = title;
            
        }else{
            _titleLabel.text = string;
            
        }
    }else if ([iphoneType isEqualToString:@"iPhone 6"] || [iphoneType isEqualToString:@"iPhone 6s"] || [iphoneType isEqualToString:@"iPhone 7"] ){
        if (string.length > 18) {
            NSString *title = [_dicProperty[@"title"] substringWithRange:NSMakeRange(0, 17)];
            
            _titleLabel.text = title;
            
        }else{
            _titleLabel.text = string;
            
        }
    }else if ([iphoneType isEqualToString:@"iPhone 6 Plus"] || [iphoneType isEqualToString:@"iPhone 6s Plus"] || [iphoneType isEqualToString:@"iPhone 7 Plus"]){
        if (string.length > 18) {
            NSString *title = [_dicProperty[@"title"] substringWithRange:NSMakeRange(0, 13)];
            
            _titleLabel.text = title;
            
        }else{
            _titleLabel.text = string;
            
        }
    }else {
        if (string.length > 14) {
            NSString *title = [_dicProperty[@"title"] substringWithRange:NSMakeRange(0, 13)];
            
            _titleLabel.text = title;
            
        }else{
            _titleLabel.text = string;
            
        }
    }
    
}

- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

- (void) bannerAction
{
    if (!_dicProperty || !_dicProperty[@"link"]) {
        return;
    }
    if (_linkAction) {
        NTGArticle *article = _dicProperty[@"article"];
        self.linkAction(article);
    }
}

@end

