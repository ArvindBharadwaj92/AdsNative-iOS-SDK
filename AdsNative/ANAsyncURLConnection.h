//
//  ANAsyncURLConnection.h
//  AdsNative
//
//  Created by Santthosh on 5/21/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//
//  http://stackoverflow.com/questions/5037545/nsurlconnection-and-grand-central-dispatch

#import <Foundation/Foundation.h>

typedef void (^onSuccess_t)(NSData *data);
typedef void (^onError_t)(NSError *error);

@interface ANAsyncURLConnection : NSObject {
    NSMutableData *data_;
    onSuccess_t onSuccess_;
    onError_t onError_;
}

+ (id)request:(NSString *)requestUrl onSuccess:(onSuccess_t)onSuccess onError:(onError_t)onError;

- (id)initWithRequest:(NSString *)requestUrl onSuccess:(onSuccess_t)onSuccess onError:(onError_t)onError;

@end
