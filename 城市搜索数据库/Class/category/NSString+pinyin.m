//
//  NSString+pinyin.m
//  城市搜索数据库
//
//  Created by mac on 16/5/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSString+pinyin.h"

@implementation NSString (pinyin)

+ (NSString *)transformTextToPinYin:(NSString *)text withSpace:(BOOL)withSpace
{
    NSMutableString *pinyin = [[NSMutableString alloc] initWithString:text];
    //将汉字转为拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyin, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, 0, kCFStringTransformStripDiacritics, NO);
    if (withSpace) {
        return pinyin;
    } else {
        return [pinyin stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
}



+ (NSString *)getFirstStrFromText:(NSString *)text
{
    NSArray *strArray = [[self transformTextToPinYin:text withSpace:YES] componentsSeparatedByString:@" "];
    
    NSMutableString *jianpin = [NSMutableString string];
    
    if (strArray && strArray.count > 0) {
        for (NSString *str in strArray) {
            NSString *firstStr = [str substringToIndex:1];
            [jianpin appendString:firstStr];
        }
    }
    
    return jianpin;
}


@end
