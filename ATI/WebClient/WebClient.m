//
//  WebClient.m
//  iPhoneStructure
//
//  Created by Marvin on 29/04/14.
//  Copyright (c) 2014 Marvin. All rights reserved.

#import "WebClient.h"
#import "NSString+extras.h"
#import "Loader.h"
#import "Common.h"
#import "WebKit.h"
#import "TKAlertCenter.h"
#import "AppDelegate.h"
#import "Helper.h"
#import "Common.h"
#import "SIAlertView.h"
#import "Messages.h"

@interface WebClient()

@end

@implementation WebClient

#pragma mark - Shared Client

+ (id)sharedClient {
    static WebClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}

#pragma mark - Get generic Path

- (void)getAtPath:(NSString *)path withParams:(NSDictionary *)params :(void(^)(id jsonData))onComplete failure:(void (^)(NSError *error))failure {
    [[Loader defaultLoader] displayLoadingView:msgLoading];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error= nil;
        if(responseObject){
            NSString *json = [[[NSString alloc] initWithData:(NSData*)responseObject encoding:NSASCIIStringEncoding] trimWhiteSpace];
            NSArray *dictArray = [json componentsSeparatedByString:@"<!-- Hosting24"];
            NSData *data = [dictArray[0] dataUsingEncoding:NSUTF8StringEncoding];
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (error){
                NSLog(@"%@",error.localizedDescription);
                NSLog(@"JSON parsing error in %@", NSStringFromSelector(_cmd));
                [[Loader defaultLoader] hideLoadingView];
                failure(error);
            } else {
                [[Loader defaultLoader] hideLoadingView];
                onComplete(jsonData);
            }
        }else{
            [[Loader defaultLoader] hideLoadingView];
            onComplete(nil);
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request failed %@ (%li)", operation.request.URL, (long)operation.response.statusCode);
        [[Loader defaultLoader] hideLoadingView];
        failure(error);
    }];
}

#pragma mark - Login Call

- (void)loginIntoApplication:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kLogin fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Register

- (void)signupIntoApplication:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[@"" fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Forgot Password Call

- (void)forgotPassword:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kForgotPassword fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get Vehicles List

- (void)getVehiclesList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetVehicles fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get Task List

- (void)getTasksList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetTasks fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get Parts List

- (void)getPartsList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetParts fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Add Call

- (void)addCall:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kAddCall fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Edit Call

- (void)editCall:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kEditCall fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Get Call List

- (void)getCallList:(NSDictionary *)params success:(WebClientCallbackSuccess)success failure:(WebClientCallbackFailure)failure{
    [self getAtPath:[kGetCallList fullPath] withParams:params:^(id jsonData) {
        success((NSDictionary*)jsonData);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
