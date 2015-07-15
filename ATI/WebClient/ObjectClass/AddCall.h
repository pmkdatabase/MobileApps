//
//  AddCall.h
//  ATI
//
//  Created by E2M164 on 18/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddCall : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *dateCompleted;

@property (assign, nonatomic) NSInteger objectid;
@property (assign, nonatomic) NSInteger empid;

@property (strong, nonatomic) NSString *taskType;

@property (strong, nonatomic) NSString *task1;
@property (strong, nonatomic) NSString *task2;
@property (strong, nonatomic) NSString *task3;

@property (strong, nonatomic) NSString *part1BCode1;
@property (strong, nonatomic) NSString *part1BCode2;
@property (strong, nonatomic) NSString *part1BCode3;

@property (assign, nonatomic) NSInteger part1id;
@property (assign, nonatomic) NSInteger part2id;
@property (assign, nonatomic) NSInteger part3id;

@property (assign, nonatomic) NSInteger qtyPart1;
@property (assign, nonatomic) NSInteger qtyPart2;
@property (assign, nonatomic) NSInteger qtyPart3;

@property (assign, nonatomic) NSInteger duration1;
@property (assign, nonatomic) NSInteger duration2;
@property (assign, nonatomic) NSInteger duration3;

@property (assign, nonatomic) BOOL status;

@end
