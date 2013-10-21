//
//  ANLogImpressionRequest.h
//  AdsNative
//
//  Created by Santthosh on 5/30/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ANSponsoredStory;

@interface ANLogImpressionRequest : NSObject

+(ANLogImpressionRequest *)requestWithSponsoredStory:(ANSponsoredStory *)story;

@property (nonatomic,strong) NSString* creative_id;
@property (nonatomic,strong) NSString* session_id;

-(NSMutableString *)getParams;

-(NSString *)getURL;

@end
