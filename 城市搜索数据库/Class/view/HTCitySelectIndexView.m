//
//  HTCitySelectIndexView.m
//  城市搜索数据库
//
//  Created by mac on 16/4/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HTCitySelectIndexView.h"
#import "UIColor+hex.h"
#define RGB(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]

@interface HTCitySelectIndexView ()
{
    BOOL isLayedOut;
    CGFloat _letterHeight;
    CAShapeLayer *_shapeLayer;

    NSString *_selectedString;
}
@end

@implementation HTCitySelectIndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _letterHeight = 13;//设置字体高度
    }
    return self;
}


- (void)setDelegate:(id<HTCitySelectIndexViewDelegate>)delegate
{
    _delegate = delegate;
    isLayedOut = NO;
    [self layoutSubviews];
}

- (void)setup{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineJoin = kCALineCapSquare;
    _shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeEnd = 1.0f;
    self.layer.masksToBounds = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
    
    if (!isLayedOut){
        
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        _shapeLayer.frame = (CGRect) {.origin = CGPointZero, .size = self.layer.frame.size};
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        
        CGFloat fontSize = 12;
        for (int i = 0; i < self.titlesArray.count; i++) {
            CGFloat originY = 0;
            
            if (i == 0) {
                originY = 0;
            } else {
                originY = _letterHeight * 2 + 8 + (i - 1) * (_letterHeight + 3);
            }
            
            CATextLayer *ctl = [self textLayerWithSize:fontSize
                                                string:self.titlesArray[i]
                                              andFrame:CGRectMake(0, originY, self.frame.size.width, ((i == 0)? _letterHeight * 2 + 9 : _letterHeight))];
            [self.layer addSublayer:ctl];
            [bezierPath moveToPoint:CGPointMake(0, originY)];
            [bezierPath addLineToPoint:CGPointMake(ctl.frame.size.width, originY)];
        }
        
        _shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:_shapeLayer];
        
        isLayedOut = YES;
    }
}


//绘制字体
- (CATextLayer*)textLayerWithSize:(CGFloat)size string:(NSString*)string andFrame:(CGRect)frame{
    CATextLayer *tl = [CATextLayer layer];
    [tl setFont:@"ArialMT"];
    [tl setFontSize:size];
    [tl setFrame:frame];
    [tl setWrapped:YES];
    [tl setAlignmentMode:kCAAlignmentCenter];
    [tl setContentsScale:[[UIScreen mainScreen] scale]];
    [tl setForegroundColor:[UIColor grayColor].CGColor];
    if ([_selectedString isEqualToString:string]) {
        [tl setForegroundColor:[UIColor colorWithHexString:@"#00a751"].CGColor];
        [tl setFontSize:18];
        [tl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 10)];
    }
    [tl setString:string];
    return tl;
}

//根据触摸点计算出点击的第几个section
- (void)sendEventToDelegate:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger index = 0;
    if (point.y < _letterHeight * 2 + 3) {
        index = 0;
    } else {
        
        index = floor(point.y - _letterHeight * 2 - 3) / (_letterHeight + 3);
    }
    
    if (index < 0 || index > self.titlesArray.count - 1) {
        return;
    }
    [self.delegate collectionViewIndex:self
                   didselectionAtIndex:index
                             withTitle:self.titlesArray[index]];
    //让选中的变色
    _selectedString = self.titlesArray[index];
    isLayedOut = NO;
    [self layoutSubviews];
}


#pragma mark -
#pragma mark Delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self sendEventToDelegate:event];
    
    [self.delegate collectionViewIndexTouchesBegan:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    [self sendEventToDelegate:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _selectedString = nil;
    isLayedOut = NO;
    [self layoutSubviews];//重新布局视图
    [self.delegate collectionViewIndexTouchesEnd:self];
}

@end
