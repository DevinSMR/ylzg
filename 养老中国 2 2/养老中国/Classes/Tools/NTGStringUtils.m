//
//  NTGStringUtils.m
//  
//
//  Created by nbc on 16/2/25.
//
//

#import "NTGStringUtils.h"

@implementation NTGStringUtils
+ (NSString *)addHttpPrefix:(NSString *)url {
    
    if (url!=nil && ![url hasPrefix:@"http://"]) {
        url = [@"http://" stringByAppendingString:url];
    }
    return url;
}
@end
