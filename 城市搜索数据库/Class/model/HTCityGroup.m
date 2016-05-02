//
//  HTCityGroup.m
//  城市搜索数据库
//
//  Created by mac on 16/5/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HTCityGroup.h"

@implementation HTCityGroup

+ (NSDictionary *)objectClassInArray{
    
    return @{
             @"cityArray":[HTCity class]
             };
}

+ (NSDictionary *)replacedKeyFromPropertyName{

    return @{
            @"groupName":@"key",
            
             @"cityArray":@"value"
            };
}

@end
