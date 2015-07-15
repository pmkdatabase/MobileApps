//
//  SearchCell.m
//  ATI
//
//  Created by E2M164 on 16/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

- (void)setTask:(Task *)task{
    _task = task;
    _lblitems.text = _task.strRepair;
}

- (void)setVehicle:(Vehicle *)vehicle{
    _vehicle = vehicle;
    _lblitems.text = _vehicle.strVehicleNo;
}

@end
