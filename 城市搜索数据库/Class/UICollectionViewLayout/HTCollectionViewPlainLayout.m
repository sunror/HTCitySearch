//
//  HTCollectionViewPlainLayout.m
//  城市搜索数据库
//
//  Created by ; on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HTCollectionViewPlainLayout.h"

@interface HTCollectionViewPlainLayout ()

@end

@implementation HTCollectionViewPlainLayout

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _naviHeight = 64.0;
    }
    return self;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    // 获取父类(UICollectionViewFlowLayout)的布局信息
    NSMutableArray *flowLayoutArr = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for (UICollectionViewLayoutAttributes *attribute in flowLayoutArr) {
        
        if (attribute.representedElementKind == UICollectionElementKindSectionHeader){
           
            
            
        }
    }
    
//    CGFloat offset = self.collectionView.contentOffset.y;
//    NSLog(@"offset=%f",offset);
    
    return flowLayoutArr.copy;

}





@end
