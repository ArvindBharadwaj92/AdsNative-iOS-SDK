//
//  ANServiceProviderProtocol.h
//  AdsNative
//
//  Created by Santthosh on 5/14/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ANResponse.h"
#import "ANGetSponsoredStoryRequest.h"
#import "ANGetSponsoredStoryResponse.h"
#import "ANLogImpressionRequest.h"
#import "ANLogTimeSpentRequest.h"

@protocol ANServiceProviderProtocol <NSObject>

// Get the sponsored story from the backend API
+(void)getSponsoredStory:(ANGetSponsoredStoryRequest *)request
                 success:(void (^)(ANGetSponsoredStoryResponse *response))success
                 failure:(void (^)(NSError *error))failure;

// Log impression view
+(void)logImpression:(ANLogImpressionRequest *)request
                 success:(void (^)(ANResponse *response))success
                 failure:(void (^)(NSError *error))failure;

// Log time spent on story
+(void)logTimeSpent:(ANLogTimeSpentRequest *)request
             success:(void (^)(ANResponse *response))success
             failure:(void (^)(NSError *error))failure;

@end
