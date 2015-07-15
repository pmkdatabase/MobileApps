//
//  CallListCell.m
//  ATI
//
//  Created by E2M164 on 15/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "CallListCell.h"
#import "Helper.h"
#import "Common.h"
#import "UtilityManager.h"

@implementation CallListCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins{
    return UIEdgeInsetsZero;
}

- (void)setTableData:(TableData *)tableData{
    _tableData = tableData;
    _lblName.text = [_tableData.strType uppercaseString];
    NSArray *date = [_tableData.strDate componentsSeparatedByString:@" "];
    NSArray *arrDate = [[Helper dateStringFromString:date[0] format:@"yyyy-MM-dd" toFormat:kDateFormat]componentsSeparatedByString:@"-"];
    _lblYY.text = arrDate[0];
    _lblMM.text = [arrDate[1] uppercaseString];
    _lblDD.text = arrDate[2];
    _lblVehicleNo.text = _tableData.strVehicleNo;
    if ([_tableData.isStatus isEqualToString:@"0"]) {
        _imgView.image = [UIImage imageNamed:@"singleTick"];
    }else{
        _imgView.image = [UIImage imageNamed:@"double_Tick"];
    }
}

- (void)setCallList:(CallList *)callList{
    _callList = callList;
    _lblName.text = [_callList.strType uppercaseString];
    NSArray *arrDate = [[Helper dateStringFromString:_callList.strDate format:kSendDateFormat toFormat:kDateTimeFormat]componentsSeparatedByString:@"-"];
    _lblYY.text = arrDate[0];
    _lblMM.text = [arrDate[1] uppercaseString];
    _lblDD.text = arrDate[2];
    _lblVehicleNo.text = _callList.strVehicleNo;
}
@end
