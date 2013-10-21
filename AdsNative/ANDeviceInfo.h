//
//  ANDeviceInfo.h
//  AdsNative
//
//  Created by Santthosh on 5/14/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANDeviceInfo : NSObject

+(NSString *)getOSVersion;

+(NSString *)getUserAgent;

+(NSString *)getDeviceModel;

+(NSString *)getLocale;

+(NSString *)getTimeZone;

+(NSString *)getIdentifierForAdvertisier;

+(NSString *)getIdentifierForVendor;

+(NSString *)getConnectionType;

+(NSString *)getODIN1;

@end
