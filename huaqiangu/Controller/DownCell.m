//
//  DownCell.m
//  huaqiangu
//
//  Created by JiangWeiGuo on 16/2/23.
//  Copyright © 2016年 Jiangwei. All rights reserved.
//

#import "DownCell.h"

@implementation DownCell


-(void)setDownCell:(TrackModel *)track{
    
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.text = track.title;
    self.chooseBtn.selected = track.isSelected;
}

- (void)awakeFromNib {
    // Initialization code
    self.chooseBtn.userInteractionEnabled = NO;
}


@end
