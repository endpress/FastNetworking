//
//  FNHttpSessionManager.h
//  FastNetworking
//
//  Created by ZhangSC on 15/12/14.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import "FNURLSessionManager.h"

@interface FNHttpSessionManager : FNURLSessionManager

+ (instancetype)manager;

- (void)sendURLString:(NSString *)URLString
     withMethod:(NSString *)method
     parameters:(NSDictionary *)parameters completionHandler:(CompletionHandler)completionHandler;

- (void)sendGETRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(CompletionHandler)completionHandler;
- (void)sendPOSTRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters completionHandler:(CompletionHandler)completionHandler;
@end
