//
//  HTCityGroup.h
//  城市搜索数据库
//
//  Created by mac on 16/5/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCity.h"
#import "MJExtension.h"

@interface HTCityGroup : NSObject

@property(nonatomic,copy) NSString *groupName;

@property(nonatomic,strong) NSArray *cityArray;

@end
