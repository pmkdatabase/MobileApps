//
//  CallListCell.h
//  ATI
//
//  Created by E2M164 on 15/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallList.h"
#import "TableData.h"

@interface CallListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblVehicleNo;
@property (strong, nonatomic) IBOutlet UILabel *lblDD;
@property (strong, nonatomic) IBOutlet UILabel *lblMM;
@property (strong, nonatomic) IBOutlet UILabel *lblYY;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) CallList *callList;
@property (strong, nonatomic) TableData *tableData;

@end
