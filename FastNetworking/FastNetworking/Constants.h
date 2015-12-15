//
//  Constants.h
//  FastNetworking
//
//  Created by ZhangSC on 15/12/14.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionHandler)(NSURLResponse *responce, id responceObject, NSError *error);

typedef void(^CacheHandler)(NSURLResponse *responce, id responceObject, NSData *data, NSError *error);

static NSString * const FNURLSessionManagerLockName = @"FNURLSessionManagerLockName";

static NSString * const FNURLTaskCompletedResponceData = @"FNURLTaskCompletedResponceData";

