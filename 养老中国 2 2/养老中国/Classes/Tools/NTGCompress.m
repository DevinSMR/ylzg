/*
 * Copyright 2005-2013 nbcyl.com. All rights reserved.
 * Support: http://www.nbcyl.com
 * License: http://www.nbcyl.com/license
 */

#import "NTGCompress.h"

/**
 * tool - 对图片URL拼接压缩的比例
 *
 * @author nbcyl Team
 * @version 3.0
 */

@implementation NTGCompress

+ (NSString *)compressUrl:(NSString *)url width:(float)width heigth:(float)heigth {
    NSMutableString *copressUrl = [[NSMutableString alloc]initWithString:url];
    if ([url isEqualToString:@""]) {
        return copressUrl;
    }
    NSString *string = @"upload";
    NSRange range = [copressUrl rangeOfString:string];
    int location = (int)range.location;
    [copressUrl insertString:[NSString stringWithFormat:@"dimgp/%.f/%.f/",width,heigth] atIndex:location];
    return copressUrl;
}

@end
