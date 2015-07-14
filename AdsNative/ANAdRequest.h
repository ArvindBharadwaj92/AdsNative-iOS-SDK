//
//  ANAdRequest.h
//  AdsNative
//
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANAdRequest : NSObject

@property (nonatomic, copy) NSString *adUnitID;

// Keywords to improve targeting
@property (nonatomic,strong) NSArray *keywords;

// Key value pairs to improve targeting
@property (nonatomic, strong) NSDictionary *parameters;

+(ANAdRequest *)requestWithAdUnitID:(NSString *)adUnitID;
+(ANAdRequest *)requestWithAdUnitID:(NSString *)aAdUnitID andKeywords:(NSArray *)aKeywords;

+(NSString *)sdkVersion;

@end