//
//  WebClient.h
//  iPhoneStructure
//
//  Created by Marvin on 29/04/14.
//  Copyright (c) 2014 Marvin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WebClientCallbackSuccess)(NSDictionary *dictionary);
typedef void(^WebClientCallbackFailure)(NSError *error);

@interface WebClient : NSObject

//Shared Client method
+ (id)sharedClient;

- (void)getAtPath:(NSString *)path withParams:(NSDictionary *)params :(void(^)(id jsonData))onComplete failure:(void (^)(NSError *error))failure;

//Login
- (void)loginIntoApplication:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)signupIntoApplication:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)forgotPassword:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Get Vehicles
- (void)getVehiclesList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Get Tasks
- (void)getTasksList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Get Parts
- (void)getPartsList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Add Call
- (void)addCall:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;
- (void)getCallList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

//Edit Call
- (void)editCall:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure;

@end
