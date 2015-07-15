//
//  CallList.m
//  ATI
//
//  Created by Manish on 20/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "CallList.h"

@implementation CallList

+ (CallList*)dataWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (CallList*)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {

        if (dict[@"Employee_Id"]  != [NSNull null])
            self.intEmpID = [dict[@"Employee_Id"]integerValue];

        if (dict[@"Servicecall_Id"]  != [NSNull null])
            self.intServiceID = [dict[@"Servicecall_Id"]integerValue];

        if (dict[@"Object_id"]  != [NSNull null])
            self.intObjectID = [dict[@"Object_id"]integerValue];

        if (dict[@"Task_1_Id"]  != [NSNull null])
            self.intRepairID1 = [dict[@"Task_1_Id"]integerValue];

        if (dict[@"Task_2_Id"]  != [NSNull null])
            self.intRepairID2 = [dict[@"Task_2_Id"]integerValue];

        if (dict[@"Task_3_Id"]  != [NSNull null])
            self.intRepairID3 = [dict[@"Task_3_Id"]integerValue];
        
        if (dict[@"Part1_Id"]  != [NSNull null])
            self.intPartID1 = [dict[@"Part1_Id"]integerValue];
        
        if (dict[@"Part2_Id"]  != [NSNull null])
            self.intPartID2 = [dict[@"Part2_Id"]integerValue];
        
        if (dict[@"Part3_Id"]  != [NSNull null])
            self.intPartID3 = [dict[@"Part3_Id"]integerValue];

        if (dict[@"Servicecall_Date"]  != [NSNull null])
            self.strDate = dict[@"Servicecall_Date"];
        
        if (dict[@"Task_Type"]  != [NSNull null])
            self.strType = dict[@"Task_Type"];
        
        if (dict[@"Vehicle_Number"]  != [NSNull null])
            self.strVehicleNo = dict[@"Vehicle_Number"];
        
        if (dict[@"DateCompleted"]  != [NSNull null])
            self.strDateCompleted = dict[@"DateCompleted"];
        
        if (dict[@"Duration1"]  != [NSNull null])
            self.strDuration1 = dict[@"Duration1"];
        
        if (dict[@"Duration2"]  != [NSNull null])
            self.strDuration2 = dict[@"Duration2"];
        
        if (dict[@"Duration3"]  != [NSNull null])
            self.strDuration3 = dict[@"Duration3"];
        
        if (dict[@"Part1LabDesc"]  != [NSNull null])
            self.strPart1Desc = dict[@"Part1LabDesc"];

        if (dict[@"Part2LabDesc"]  != [NSNull null])
            self.strPart2Desc = dict[@"Part2LabDesc"];
        
        if (dict[@"Part3LabDesc"]  != [NSNull null])
            self.strPart3Desc = dict[@"Part3LabDesc"];
        
        if (dict[@"QtyPart1"]  != [NSNull null])
            self.strPart1Qty = dict[@"QtyPart1"];

        if (dict[@"QtyPart2"]  != [NSNull null])
            self.strPart2Qty = dict[@"QtyPart2"];

        if (dict[@"QtyPart3"]  != [NSNull null])
            self.strPart3Qty = dict[@"QtyPart3"];

        if (dict[@"Task_1"]  != [NSNull null])
            self.strTask1Name = dict[@"Task_1"];
        
        if (dict[@"Task_2"]  != [NSNull null])
            self.strTask2Name = dict[@"Task_2"];
        
        if (dict[@"Task_3"]  != [NSNull null])
            self.strTask3Name = dict[@"Task_3"];
        
        if (dict[@"Part1Name"]  != [NSNull null])
            self.strPart1Name = dict[@"Part1Name"];
        
        if (dict[@"Part2Name"]  != [NSNull null])
            self.strPart2Name = dict[@"Part2Name"];
        
        if (dict[@"Part3Name"]  != [NSNull null])
            self.strPart3Name = dict[@"Part3Name"];

        if (dict[@"Part1Barcode"]  != [NSNull null])
            self.strPart1Bcode = dict[@"Part1Barcode"];
        
        if (dict[@"Part2Barcode"]  != [NSNull null])
            self.strPart2Bcode = dict[@"Part2Barcode"];
        
        if (dict[@"Part3Barcode"]  != [NSNull null])
            self.strPart3Bcode = dict[@"Part3Barcode"];

        if (dict[@"Status"]  != [NSNull null])
            self.strStatus = dict[@"Status"];
    }
    return self;
}

@end
