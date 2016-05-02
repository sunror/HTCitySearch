//
//  HTCity.h
//  城市搜索数据库
//
//  Created by mac on 16/5/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCity : NSObject

@property(nonatomic,strong) NSString *mid;

@property(nonatomic,copy) NSString *cityId;

@property(nonatomic,copy) NSString *cityName;

@property(nonatomic,copy) NSString *pinyinName;

@property(nonatomic,copy) NSString *shortName;


@end
