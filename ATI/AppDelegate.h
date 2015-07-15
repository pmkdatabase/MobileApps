//
//  AppDelegate.h
//  ATI
//
//  Created by E2M164 on 15/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic) BOOL firstTime;

@property (strong, nonatomic) NSString *strVehicleNo;
@property (strong, nonatomic) NSString *strTask1;
@property (strong, nonatomic) NSString *strTask2;
@property (strong, nonatomic) NSString *strTask3;
@property (strong, nonatomic) NSString *strPart1Name;
@property (strong, nonatomic) NSString *strPart2Name;
@property (strong, nonatomic) NSString *strPart3Name;
@property (strong, nonatomic) NSString *strPart1ID;
@property (strong, nonatomic) NSString *strPart2ID;
@property (strong, nonatomic) NSString *strPart3ID;
@property (strong, nonatomic) NSString *strObjectID;

@end

