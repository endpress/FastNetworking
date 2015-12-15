//
//  FastRequestCache.h
//  FastNetworking
//
//  Created by ZhangSC on 15/12/15.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FastRequestCache : NSObject

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, assign) NSInteger *maxCacheAge;
@property (nonatomic, assign) NSInteger *maxCacheSize;

@property (nonatomic, strong) dispatch_queue_t operateQueue;

/*
 存放已经缓存的请求目录
 */
@property (nonatomic, strong) NSSet *cachedRequest;

+ (instancetype)manager;

- (NSData *)getRequestCacheDataForKey:(NSString *)key;
- (void)storeRequestData:(NSData *)data ForKey:(NSString *)key;

@end
