//
//  part.h
//  ATI
//
//  Created by E2M164 on 18/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface part : NSObject

@property (strong, nonatomic) NSString *partNo;
@property (strong, nonatomic) NSString *partBarcode;
@property (strong, nonatomic) NSString *partDesc;
@property (strong, nonatomic) NSString *partName;
@property (strong, nonatomic) NSString *partUnitType;
@property (assign, nonatomic) NSInteger intPartID;

@property (strong, nonatomic) NSAttributedString *attributedDescString;

@property (assign, nonatomic, getter=isOpen) BOOL open;

+ (part*)dataWithDict:(NSDictionary*)dict;
- (part*)initWithDictionary:(NSDictionary*)dict;

@end
