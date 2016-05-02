//
//  HTDataBase.m
//  城市搜索数据库
//
//  Created by mac on 16/5/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HTDataBase.h"


#define dataBaseName @"city.db"

@interface HTDataBase ()

@property(nonatomic,strong) FMDatabase *database;

@property(nonatomic,strong) NSMutableArray<HTCity *> *resultArray;

@end

@implementation HTDataBase

- (NSMutableArray *)resultArray{
    
    if (_resultArray == nil) {
        _resultArray = [[NSMutableArray alloc] init];
    }
    return _resultArray;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dataBaseName];
        
        // 加载数据库 databaseWithPath: 方法有一个特点, 如果数据库存在就直接打开数据库, 如果数据库不存在会先创建再打开
        self.database = [FMDatabase databaseWithPath:filename];
        
        if ([self.database open]) {
            
            NSLog(@"数据库打开成功");
            // 创建表
            // 注意: 在FMDB中除了查询以外的操作都称之为UPDATA
            NSString *sql = @"CREATE TABLE IF NOT EXISTS t_city (name TEXT , py TEXT,pinyin TEXT, mid TEXT , cityId TEXT, id INTEGER PRIMARY KEY AUTOINCREMENT);";
            
           BOOL result = [self.database executeUpdate:sql];
            
            if (result) {
                
                NSLog(@"创建表成功");
                
            } else{
                NSLog(@"创建表失败");
            }
        }else{
            NSLog(@"数据库打开失败");
        }
    
        
    }
    return self;
}

+ (instancetype)getDataBase{


    static HTDataBase *dataBase;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    // 全局变量 - block中可以操作
       dataBase = [[self alloc] init];
        
    });
    return dataBase;
}

- (void)deleteTable:(NSString *)sql{

   BOOL success = [self.database executeUpdate:sql];
    if (success) {
        NSLog(@"删除数据成功");
    }
}

// 插入数据
- (BOOL)saveCityDataWithModel:(HTCity *)city{
    
    if([self.database executeUpdate:@"INSERT INTO  t_city (name,py,pinyin,mid,cityId) VALUES(?,?,?,?,?);", city.cityName,city.shortName,city.pinyinName,city.mid,city.cityId])
    {
        NSLog(@"插入表成功");
        return YES;

    }else
    {
        NSLog(@"插入表失败");
        return NO;
    }

}

- (NSArray *)quaryDataFromTable:(NSString *)sql{
    
    [self.resultArray removeAllObjects];

    // %% 转译
//    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_city WHERE name LIKE '%%%@%%' OR pinyin LIKE '%%%@%%' OR py LIKE '%%%@%%';",sql,sql,sql];
    
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM t_city WHERE name LIKE '%@%%' OR pinyin LIKE '%@%%'  OR py LIKE '%@%%' ;",sql,sql,sql];

    FMResultSet *set = [self.database executeQuery:sqlStr];
    
    while ([set next]) {
        
        NSString *name = [set stringForColumnIndex:0];
        NSString *py = [set stringForColumnIndex:1];
        NSString *pinyin = [set stringForColumnIndex:2];
        NSString *mid = [set stringForColumnIndex:3];
        NSString *cityId = [set stringForColumnIndex:4];
        
        HTCity *city = [[HTCity alloc] init];
        city.cityName = name;
        city.pinyinName = pinyin;
        city.shortName = py;
        city.mid = mid;
        city.cityId = cityId;
        
        [self.resultArray addObject:city];
    }
    
    return self.resultArray;
}

@end
