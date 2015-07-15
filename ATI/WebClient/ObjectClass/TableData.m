//
//  TableData.m
//  ATI
//
//  Created by Manish Dudharejia on 04/06/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "TableData.h"

@implementation TableData

+ (TableData*)dataWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (TableData*)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
        if (dict[@"servicecall_id"]  != [NSNull null])
            self.intServicecall_id = [dict[@"servicecall_id"]integerValue];
        
        if (dict[@"objectid"]  != [NSNull null])
            self.strObjectID = dict[@"objectid"];

        if (dict[@"date"]  != [NSNull null])
            self.strDate = dict[@"date"];
        
        if (dict[@"datecompleted"]  != [NSNull null])
            self.strDateCompleted = dict[@"datecompleted"];
        
        if (dict[@"task_type"]  != [NSNull null])
            self.strType = dict[@"task_type"];
        
        if (dict[@"vehicleno"]  != [NSNull null])
            self.strVehicleNo = dict[@"vehicleno"];
        
        if (dict[@"duration1"]  != [NSNull null])
            self.strDuration1 = dict[@"duration1"];
        
        if (dict[@"duration2"]  != [NSNull null])
            self.strDuration2 = dict[@"duration2"];
        
        if (dict[@"duration3"]  != [NSNull null])
            self.strDuration3 = dict[@"duration3"];
        
        if (dict[@"part1name"]  != [NSNull null])
            self.strPart1Name = dict[@"part1name"];
        
        if (dict[@"part2name"]  != [NSNull null])
            self.strPart2Name = dict[@"part2name"];
        
        if (dict[@"part3name"]  != [NSNull null])
            self.strPart3Name = dict[@"part3name"];

        if (dict[@"part1desc"]  != [NSNull null])
            self.strPart1Desc = dict[@"part1desc"];
        
        if (dict[@"part2desc"]  != [NSNull null])
            self.strPart2Desc = dict[@"part2desc"];
        
        if (dict[@"part3desc"]  != [NSNull null])
            self.strPart3Desc = dict[@"part3desc"];
        
        if (dict[@"part1bcode"]  != [NSNull null])
            self.strPart1Bcode = dict[@"part1bcode"];
        
        if (dict[@"part2bcode"]  != [NSNull null])
            self.strPart2Bcode = dict[@"part2bcode"];
        
        if (dict[@"part3bcode"]  != [NSNull null])
            self.strPart3Bcode = dict[@"part3bcode"];

        if (dict[@"qtypart1"]  != [NSNull null])
            self.strPart1Qty = dict[@"qtypart1"];
        
        if (dict[@"qtypart2"]  != [NSNull null])
            self.strPart2Qty = dict[@"qtypart2"];
        
        if (dict[@"qtypart3"]  != [NSNull null])
            self.strPart3Qty = dict[@"qtypart3"];
        
        if (dict[@"task1"]  != [NSNull null])
            self.strTask1 = dict[@"task1"];
        
        if (dict[@"task2"]  != [NSNull null])
            self.strTask2 = dict[@"task2"];
        
        if (dict[@"task3"]  != [NSNull null])
            self.strTask3 = dict[@"task3"];
        
        if (dict[@"task1name"]  != [NSNull null])
            self.strTask1Name = dict[@"task1name"];
        
        if (dict[@"task2name"]  != [NSNull null])
            self.strTask2Name = dict[@"task2name"];
        
        if (dict[@"task3name"]  != [NSNull null])
            self.strTask3Name = dict[@"task3name"];
        
        if (dict[@"status"]  != [NSNull null])
            self.strStatus = dict[@"status"];
        
        if (dict[@"isstatus"]  != [NSNull null])
            self.isStatus = dict[@"isstatus"];

    }
    return self;
}

@end
