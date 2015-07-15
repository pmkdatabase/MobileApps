//
//  Vehicle.h
//  ATI
//
//  Created by Manish on 16/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vehicle : NSObject

@property (assign, nonatomic) NSInteger intObjectID;
@property (strong, nonatomic) NSString *strVehicleNo;

+ (Vehicle*)dataWithDict:(NSDictionary*)dict;
- (Vehicle*)initWithDictionary:(NSDictionary*)dict;

@end
