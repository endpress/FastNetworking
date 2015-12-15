//
//  FNURLSessionManager.h
//  FastNetworking
//
//  Created by ZhangSC on 15/12/14.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class FastRequestCache;

@interface FNURLSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>
/*
 session and operationQueue
 */
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

/*
 the task currently run by session
 */
@property (nonatomic, strong) NSArray *tasks;
@property (nonatomic, strong) NSArray *dataTasks;
@property (nonatomic, strong) NSArray *downloadTasks;
@property (nonatomic, strong) NSArray *uploadTasks;

/*
 the completion queue, default main queue
 */
@property (nonatomic, strong) dispatch_queue_t completionQueue;

/*
 the completion group, default a private group
 */
@property (nonatomic, strong) dispatch_group_t completionGroup;

/*
 completion block
 */
@property (nonatomic, copy) CompletionHandler completionHandler;

/*
 NSLock
 */
@property (nonatomic, strong) NSLock *lock;

/*
 缓存
 */
@property (nonatomic, strong)FastRequestCache *requestCache;


- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                        withCompletionHandler:(CompletionHandler)completionHandler;

- (NSError *)creatErrorWithString:(NSString *)errorString;

@end
