//
//  PartCell.h
//  ATI
//
//  Created by Manish on 27/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "part.h"

@interface PartCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblitems;
@property (strong, nonatomic) part *parts;

@end
