//
//  Task.m
//  ATI
//
//  Created by Manish on 16/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "Task.h"

@implementation Task

+ (Task*)dataWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (Task*)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
        if (dict[@"repair_id"]  != [NSNull null])
            self.intRepairID = [dict[@"repair_id"]integerValue];
        
        if (dict[@"Task_category"]  != [NSNull null])
            self.strTaskCat = dict[@"Task_category"];
        
        if (dict[@"repair"]  != [NSNull null])
            self.strRepair = dict[@"repair"];
    }
    return self;
}

@end
