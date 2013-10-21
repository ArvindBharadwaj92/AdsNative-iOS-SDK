//
//  ANLogTimeSpentRequest.h
//  AdsNative
//
//  Created by Santthosh on 5/30/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import "ANLogImpressionRequest.h"

@interface ANLogTimeSpentRequest : ANLogImpressionRequest

+(ANLogTimeSpentRequest *)requestWithSponsoredStory:(ANSponsoredStory *)story timespent:(int)timespent;

@property (nonatomic,assign) int timespent;

@end
