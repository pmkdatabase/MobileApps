//
//  NextViewController.h
//  ATI
//
//  Created by Manish Dudharejia on 30/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallList.h"
#import "TableData.h"

@interface NextViewController : UIViewController

@property (strong, nonatomic) NSString *strDD;
@property (strong, nonatomic) NSString *strMM;
@property (strong, nonatomic) NSString *strYY;
@property (strong, nonatomic) NSString *strCompletedDD;
@property (strong, nonatomic) NSString *strCompletedMM;
@property (strong, nonatomic) NSString *strCompletedYY;
@property (strong, nonatomic) NSString *strVehicleNo;
@property (strong, nonatomic) NSString *strObjectID;
@property (strong, nonatomic) NSString *strType;
@property (strong, nonatomic) NSString *strTask1;
@property (strong, nonatomic) NSString *strTask2;
@property (strong, nonatomic) NSString *strTask3;
@property (strong, nonatomic) NSString *strStatus;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) NSString *timedate,*timecompletedDate;

@property (strong, nonatomic) CallList *callList;
@property (strong, nonatomic) TableData *tableData;

@end
