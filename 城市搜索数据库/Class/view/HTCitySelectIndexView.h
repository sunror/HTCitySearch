//
//  HTCitySelectIndexView.h
//  城市搜索数据库
//
//  Created by mac on 16/4/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTCitySelectIndexView;;
@protocol HTCitySelectIndexViewDelegate <NSObject>

/**
 *  触摸到索引时的反应
 *
 *  @param collectionViewIndex 触发的对象
 *  @param index               触发的索引的下标
 *  @param title               触发的索引的文字
 */
-(void)collectionViewIndex:(HTCitySelectIndexView *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title;

/**
 *  开始触摸索引
 *
 *  @param tableViewIndex 触发tableViewIndexTouchesBegan对象
 */
- (void)collectionViewIndexTouchesBegan:(HTCitySelectIndexView *)collectionViewIndex;


/**
 *  触摸索引结束
 *
 *  @param tableViewIndex
 */
- (void)collectionViewIndexTouchesEnd:(HTCitySelectIndexView *)collectionViewIndex;

@end


@interface HTCitySelectIndexView : UIView

//索引内容数组
@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, assign) id<HTCitySelectIndexViewDelegate> delegate;


@end
