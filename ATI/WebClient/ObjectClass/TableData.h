//
//  TableData.h
//  ATI
//
//  Created by Manish Dudharejia on 04/06/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableData : NSObject

@property (assign, nonatomic) NSInteger intServicecall_id;

@property (strong, nonatomic) NSString *strDate;
@property (strong, nonatomic) NSString *strDateCompleted;

@property (strong, nonatomic) NSString *strType;

@property (strong, nonatomic) NSString *strObjectID;
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

@property (strong, nonatomic) NSString *strStatus;

@property (strong, nonatomic) NSString *isStatus;

+ (TableData*)dataWithDict:(NSDictionary*)dict;
- (TableData*)initWithDictionary:(NSDictionary*)dict;

@end
