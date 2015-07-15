//
//  User.m
//  smoozel1
//
//  Created by E2M164 on 08/05/15.
//  Copyright (c) 2015 E2M164. All rights reserved.
//

#define kUserID                 @"UserID"
#define kUserName               @"UserName"
#define kFirstName              @"FirstName"
#define kLastName               @"LastName"
#define kUserEmail              @"UserEmail"
#define kPassword               @"Password"
#define kIsLogin                @"IsLogin"
#define kDeviceToken            @"DeviceToken"
#define kEmpID                  @"EmpID"
#define kIsRememberMe           @"Remember"

#import "User.h"
#import "Common.h"
#import "Helper.h"
#import "TKAlertCenter.h"


@implementation User

+ (User*)sharedUser{
    static User *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        User *user = [Helper getCustomObjectToUserDefaults:kUserInformation];
        if(!user){
            sharedUser = [[User alloc] init];
        }else {
            sharedUser = user;
        }
    });
    return sharedUser;
}

- (instancetype)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (User *)dataWithInfo:(NSDictionary*)dict{
    return [[self alloc] initWithDict:dict];
}

- (void)initWithDictionary:(NSDictionary*)dict{
    User *user = [User sharedUser];
    user.intUserID = [dict[@"EmployeeID"] integerValue];
    
    if(dict[@"EmployeeID"]!=[NSNull null])
        user.intEmpID = [dict[@"EmployeeID"] integerValue];

    if(dict[@"Email"]!=[NSNull null])
        user.strEmail = dict[@"Email"];
    
    if(dict[@"First"]!=[NSNull null])
        user.strFirstName = dict[@"First"];
    
    if(dict[@"Last"]!=[NSNull null])
        user.strLastName = dict[@"Last"];

    if(dict[@"Pwd"]!=[NSNull null])
        user.strPassword = dict[@"Pwd"];
    
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeBool:self.rememberMe forKey:kIsRememberMe];
    [encoder encodeBool:self.login forKey:kIsLogin];
    [encoder encodeInteger:self.intUserID forKey:kUserID];
    [encoder encodeInteger:self.intEmpID forKey:kEmpID];
    [encoder encodeObject:self.strEmail forKey:kUserEmail];
    [encoder encodeObject:self.strUserName forKey:kUserName];
    [encoder encodeObject:self.strFirstName forKey:kFirstName];
    [encoder encodeObject:self.strLastName forKey:kLastName];
    [encoder encodeObject:self.strDeviceToken forKey:kDeviceToken];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if( self != nil ) {
        self.rememberMe = [decoder decodeBoolForKey:kIsRememberMe];
        self.login = [decoder decodeBoolForKey:kIsLogin];
        self.intUserID = [decoder decodeIntegerForKey:kUserID];
        self.intEmpID = [decoder decodeIntegerForKey:kEmpID];
        self.strUserName = [decoder decodeObjectForKey:kUserName];
        self.strFirstName = [decoder decodeObjectForKey:kFirstName];
        self.strLastName = [decoder decodeObjectForKey:kLastName];
        self.strEmail = [decoder decodeObjectForKey:kUserEmail];
        self.strDeviceToken = [decoder decodeObjectForKey:kDeviceToken];
    }
    return self;
}

+ (BOOL)saveCredentials:(NSDictionary*)json{
    BOOL success = [json[@"success"] boolValue];
    if (success) {
        NSLog(@"jsonres:%@",json);
        [[User sharedUser] initWithDictionary:json[@"userdata"]];
    }else {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:json[@"message"] image:kErrorImage];
    }
    return success;
}

@end
