//
//  Vehicle.m
//  ATI
//
//  Created by Manish on 16/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import "Vehicle.h"

@implementation Vehicle

+ (Vehicle*)dataWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (Vehicle*)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
        if (dict[@"object_id"]  != [NSNull null])
            self.intObjectID = [dict[@"object_id"]integerValue];
        
        if (dict[@"vehicle_no"]  != [NSNull null])
            self.strVehicleNo = dict[@"vehicle_no"];
    }
    return self;
}

@end
