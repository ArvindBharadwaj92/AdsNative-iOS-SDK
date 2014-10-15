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

@protocol ANServiceProviderProtocol <NSObject>

// Get the sponsored story from the backend API
+(void)getSponsoredStory:(ANGetSponsoredStoryRequest *)request
                 success:(void (^)(ANGetSponsoredStoryResponse *response))success
                 failure:(void (^)(NSError *error))failure;

+(void)logClick:(ANSponsoredStory *) sponsoredStory
        success:(void (^)(NSData *response))success
        failure:(void (^)(NSError *error))failure;

@end
