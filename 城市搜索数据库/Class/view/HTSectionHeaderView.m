//
//  HTSectionHeaderView.m
//  城市搜索数据库
//
//  Created by mac on 16/4/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HTSectionHeaderView.h"

@interface HTSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation HTSectionHeaderView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setHeaderName:(NSString *)headerName{

    _headerName = headerName;
    self.headerLabel.text = headerName;
}

@end
