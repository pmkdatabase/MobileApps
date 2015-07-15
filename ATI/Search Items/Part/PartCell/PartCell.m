//
//  PartCell.m
//  ATI
//
//  Created by Manish on 27/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "PartCell.h"

@implementation PartCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

-(void)setParts:(part *)parts{
    _parts = parts;
    _lblitems.text = _parts.partNo;
}

@end
