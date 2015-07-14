//
//  ANGetSponsoredStoryRequest.h
//  AdsNative
//
//  Created by Santthosh on 5/14/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANAdRequest.h"

@interface ANGetSponsoredStoryRequest : NSObject

@property (nonatomic, copy) NSString *adUnitID;
@property (nonatomic, strong) NSArray *keywords;

+(ANGetSponsoredStoryRequest *)requestWithANAdRequest:(ANAdRequest *)request;

-(NSString *)getURL;

@end
