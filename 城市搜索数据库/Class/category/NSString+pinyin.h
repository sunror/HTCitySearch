//
//  NSString+pinyin.h
//  城市搜索数据库
//
//  Created by mac on 16/5/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (pinyin)

//将汉字转换成拼音,是否保留空格
+ (NSString *)transformTextToPinYin:(NSString *)text withSpace:(BOOL)withSpace;

//将汉字转换成拼音并获取首字母简拼
+ (NSString *)getFirstStrFromText:(NSString *)text;

@end
