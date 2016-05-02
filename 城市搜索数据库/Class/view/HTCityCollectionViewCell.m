//
//  HTCityCollectionViewCell.m
//  城市搜索数据库
//
//  Created by mac on 16/4/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HTCityCollectionViewCell.h"

@interface HTCityCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
@implementation HTCityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_citySelect_default_backImage"]];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_citySelect_click_backImage"]];
}

- (void)setCellName:(NSString *)cellName{

    _cellName = cellName;
    
    self.textLabel.text = cellName;
}

@end
