//
//  Task.h
//  ATI
//
//  Created by Manish on 16/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (assign, nonatomic) NSInteger intRepairID;
@property (strong, nonatomic) NSString *strTaskCat;
@property (strong, nonatomic) NSString *strRepair;

+ (Task*)dataWithDict:(NSDictionary*)dict;
- (Task*)initWithDictionary:(NSDictionary*)dict;

@end
