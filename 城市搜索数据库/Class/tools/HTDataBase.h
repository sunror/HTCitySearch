//
//  HTDataBase.h
//  城市搜索数据库
//
//  Created by mac on 16/5/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HTCity.h"
#import "FMDatabase.h"



@interface HTDataBase : NSObject

+ (instancetype)getDataBase;

// 插入数据
- (BOOL)saveCityDataWithModel:(HTCity *)city;

// 查询数据
- (NSArray *)quaryDataFromTable:(NSString *)sql;

// 删除表
- (void)deleteTable:(NSString *)sql;

@end


