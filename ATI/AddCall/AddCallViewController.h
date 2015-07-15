//
//  AddCallViewController.h
//  ATI
//
//  Created by E2M164 on 15/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Vehicle.h"
#import "CallList.h"
#import "TableData.h"

@interface AddCallViewController : UIViewController

@property (strong, nonatomic) CallList *callList;
@property (strong, nonatomic) TableData *tableData;
@property (strong, nonatomic) NSString *strTitle;

-(void)setVehicleNo:(Vehicle*)vehicleNo;
-(void)setTask1:(Task*)task1;
-(void)setTask2:(Task*)task2;
-(void)setTask3:(Task*)task3;

@end
