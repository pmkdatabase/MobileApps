//
//  CallList.h
//  ATI
//
//  Created by Manish on 20/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallList : NSObject

@property (assign, nonatomic) NSInteger intEmpID;
@property (assign, nonatomic) NSInteger intServiceID;
@property (assign, nonatomic) NSInteger intObjectID;
@property (assign, nonatomic) NSInteger intRepairID1;
@property (assign, nonatomic) NSInteger intRepairID2;
@property (assign, nonatomic) NSInteger intRepairID3;
@property (assign, nonatomic) NSInteger intPartID1;
@property (assign, nonatomic) NSInteger intPartID2;
@property (assign, nonatomic) NSInteger intPartID3;
@property (assign, nonatomic) NSInteger intTaskID1;
@property (assign, nonatomic) NSInteger intTaskID2;
@property (assign, nonatomic) NSInteger intTaskID3;

@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strDateCompleted;

@property (strong, nonatomic) NSString *strType;

@property (strong, nonatomic) NSString *strVehicleNo;

@property (strong, nonatomic) NSString *strDuration1;
@property (strong, nonatomic) NSString *strDuration2;
@property (strong, nonatomic) NSString *strDuration3;

@property (strong, nonatomic) NSString *strPart1Name;
@property (strong, nonatomic) NSString *strPart2Name;
@property (strong, nonatomic) NSString *strPart3Name;

@property (strong, nonatomic) NSString *strPart1Desc;
@property (strong, nonatomic) NSString *strPart2Desc;
@property (strong, nonatomic) NSString *strPart3Desc;

@property (strong, nonatomic) NSString *strPart1Bcode;
@property (strong, nonatomic) NSString *strPart2Bcode;
@property (strong, nonatomic) NSString *strPart3Bcode;

@property (strong, nonatomic) NSString *strPart1Qty;
@property (strong, nonatomic) NSString *strPart2Qty;
@property (strong, nonatomic) NSString *strPart3Qty;

@property (strong, nonatomic) NSString *strTask1;
@property (strong, nonatomic) NSString *strTask2;
@property (strong, nonatomic) NSString *strTask3;

@property (strong, nonatomic) NSString *strTask1Name;
@property (strong, nonatomic) NSString *strTask2Name;
@property (strong, nonatomic) NSString *strTask3Name;

@property (strong, nonatomic) NSString *isStatus;

@property (strong, nonatomic) NSString *strStatus;

+ (CallList*)dataWithDict:(NSDictionary*)dict;
- (CallList*)initWithDictionary:(NSDictionary*)dict;

@end
