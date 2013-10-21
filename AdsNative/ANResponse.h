//
//  ANResponse.h
//  AdsNative
//
//  Created by Santthosh on 5/30/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANResponse : NSObject

@property (nonatomic,strong) NSString* status;
@property (nonatomic,strong) NSString* error;

+(ANResponse *)responseWithData:(NSData *)data;

@end
