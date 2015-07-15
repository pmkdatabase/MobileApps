//
//  SearchCell.h
//  ATI
//
//  Created by E2M164 on 16/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Vehicle.h"

@interface SearchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblitems;
@property (strong, nonatomic) Task *task;
@property (strong, nonatomic) Vehicle *vehicle;

@end
