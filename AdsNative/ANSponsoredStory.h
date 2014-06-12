//
//  AdsNative.h
//  AdsNative
//
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HandleSelectBlock)();

@class ANAdRequest;

@interface ANSponsoredStory : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *summary;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *promoted_by;
@property (nonatomic,strong) NSString *promoted_by_tag;
@property (nonatomic,strong) NSString *promoted_by_url;
@property (nonatomic,strong) NSString *thumbnail_url;
@property (nonatomic,strong) NSString *embed_url;
@property (nonatomic,strong) NSString *creative_id;
@property (nonatomic,strong) NSString *campaign_id;
@property (nonatomic,strong) NSString *session_id;
@property (nonatomic,strong) NSString *zone_id;
@property (nonatomic,strong) NSString *trackingTags;

// Load the ANAdRequest 
+(void)loadRequest:(ANAdRequest *)request
         onSuccess:(void (^)(ANSponsoredStory *story))success
           onError:(void (^)(NSError *))error;

// Attach the story to a view after the content is rendered
-(void)attachToView:(UIView *)view onSelect:(HandleSelectBlock)block;

// Attach the story to a view after the full content is rendered (typically on select)
-(void)attachFullContentToView:(UIView *)view;

// Detach the story from a view for view recycling as in a UITableViewCell
-(void)detachFromView:(UIView *)view;

// Detach all associated sponsored stories from a given view as in UITableViewCell
+(void)detachSponsoredStoriesFromView:(UIView *)view;

@end
