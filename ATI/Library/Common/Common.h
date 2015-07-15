//
//  Common.h
//  FlipIn
//
//  Created by Marvin on 20/11/13.
//  Copyright (c) 2013 Marvin. All rights reserved.
//
#import "User.h"
#import "Messages.h"

#ifndef iPhoneStructure_Common_h
#define iPhoneStructure_Common_h


#define kapiKey                                  @"123456789"
#define kdeviceType                              @"ios"
#define kappName                                 @"Smoozle"
#define kdeviceToken                             @"0123456789afdgaabbbcccfdgnerbgerbvobeov7"

#define isiPhone5                               (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define kUserDirectoryPath                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
#define IS_IOS7_OR_GREATER                      [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f ? YES : NO
#define PLAYER                                  [MPMusicPlayerController iPodMusicPlayer]

#define kRandomPasswordString                   @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

#define DegreesToRadians(degrees)               (degrees * M_PI / 180)
#define RadiansToDegrees(radians)               (radians * 180/M_PI)

#define kGeoCodingString                        @"http://maps.google.com/maps/geo?q=%f,%f&output=csv"
#define kNotificationMessage                    @"Notification Message."
#define kRemindMeNotificationDataKey            @"kRemindMeNotificationDataKey"

#define kDateFormat                             @"yyyy-MMM-dd"
#define kDateTimeFormat                         @"yyyy-MMM-dd hh:mm:ss"
#define kSendDateFormat                         @"yyyy-MM-dd hh:mm:ss"
#define kTimeFormat                             @"HH:mm"

#define kErrorImage                             [UIImage imageNamed:@"error"]
#define kRightImage                             [UIImage imageNamed:@"right"]

#define kUserInformation                        @"UserInformation"
#define kLocationUnit                           @"LocationUnit"
#define kGuideViewDisplay                       @"GuideViewDisplay"

#define appId                                   @"963423076"
#define appNameing                              @"Weather : Universal Forecast"
#define iTunesURL                                @"itms-apps://itunes.apple.com/app/id963423076"

#define EmailSubject                            @"Weather-Universal Forecast Support"
#define EmailRecipient                          @"Test@test.com"

//Product Identifier
#define UNLOCK_ALL_FEATURES                     @"com.bcd.weather.removeadsaddmorecity"

#define IPHONE4S                                [UIScreen mainScreen].bounds.size.height==480
#define IPHONE5S                                [UIScreen mainScreen].bounds.size.height==568
#define IPHONE6                                 [UIScreen mainScreen].bounds.size.height==667
#define IPHONE6PLUS                             [UIScreen mainScreen].bounds.size.height==736
#define IPAD                                    [UIScreen mainScreen].bounds.size.height==1024

#define NUMBER_OF_CITY_BEFORE_UNLOCK            2


//Google Ads
#define kGOOGLE_ADS_UNITid                      @"ca-app-pub-1474799636440583/7162113354"

//WORLD WETHER ONLINE
#define kWorldWeatherOnlineAPIKey               @"df2d43ec5aa40b68acef3733e7a3a"
#define WEATHER_FORECAST_TABLE_NAME             @"WeatherForecast"

#endif
