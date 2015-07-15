//
//  User.h
//  smoozel1
//
//  Created by E2M164 on 08/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic) NSInteger intUserID;
@property (assign, nonatomic) NSInteger intEmpID;
@property (assign, nonatomic) NSInteger intLastServiceId;

@property (strong, nonatomic) NSString *strUserName;
@property (strong, nonatomic) NSString *strFirstName;
@property (strong, nonatomic) NSString *strLastName;
@property (strong, nonatomic) NSString *strPassword;
@property (strong, nonatomic) NSString *strEmail;
@property (strong, nonatomic) NSString *strDeviceToken;
@property (strong, nonatomic) NSString *strLatitude;
@property (strong, nonatomic) NSString *strLongitude;

@property (assign, nonatomic, getter=isRememberMe) BOOL rememberMe;
@property (assign, nonatomic, getter=isLogin) BOOL login;

+ (User*)sharedUser;

+ (User *)dataWithInfo:(NSDictionary*)dict;
- (void)initWithDictionary:(NSDictionary*)dict;

+ (BOOL)saveCredentials:(NSDictionary*)json;


@end
