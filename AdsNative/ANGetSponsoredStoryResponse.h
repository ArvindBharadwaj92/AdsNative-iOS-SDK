//
//  ANGetSponsoredStoryResponse.h
//  AdsNative
//
//  Created by Santthosh on 5/14/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANResponse.h"

@class ANSponsoredStory;

@interface ANGetSponsoredStoryResponse : ANResponse

@property (nonatomic,assign) int count;
@property (nonatomic,strong) NSString* uuid;
@property (nonatomic,strong) ANSponsoredStory *sponsoredStory;

+(ANGetSponsoredStoryResponse *)responseWithData:(NSData *)data;

@end
