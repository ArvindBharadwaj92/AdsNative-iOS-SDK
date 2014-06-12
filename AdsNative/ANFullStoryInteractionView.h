//
//  ANFullStoryInteractionView.h
//  AdsNative
//
//  Created by Kuldeep Kapade on 10/17/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSponsoredStory.h"

typedef void (^RecordTimeSpentBlock)(ANSponsoredStory *, int);

@interface ANFullStoryInteractionView : UIView {
@private
    RecordTimeSpentBlock _recordTimeSpentBlock;
}


@property (nonatomic,strong)ANSponsoredStory *story;

-(id)initWithFrame:(CGRect)frame recordImpressionBlock:(RecordTimeSpentBlock)block forStory:(ANSponsoredStory *)story;

@end
