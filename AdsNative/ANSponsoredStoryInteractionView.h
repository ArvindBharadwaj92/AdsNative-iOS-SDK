//
//  ANInteractionView.h
//  AdsNative
//
//  Created by Santthosh on 5/21/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSponsoredStory.h"

typedef void (^RecordImpressionBlock)(ANSponsoredStory *);

@interface ANSponsoredStoryInteractionView : UIView {
    @private
        RecordImpressionBlock _recordImpressionBlock;
}

@property (nonatomic,strong)ANSponsoredStory *story;

-(id)initWithFrame:(CGRect)frame recordImpressionBlock:(RecordImpressionBlock)block forStory:(ANSponsoredStory *)story;

@end
