//
//  FNURLSessionManager.m
//  FastNetworking
//
//  Created by ZhangSC on 15/12/14.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import "FNURLSessionManager.h"

static dispatch_queue_t url_session_manager_creat_dataTask_queue() {
    static dispatch_queue_t fn_url_session_manager_creat_dataTask_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fn_url_session_manager_creat_dataTask_queue = dispatch_queue_create("fn_url_session_manager_creat_dataTask_queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return fn_url_session_manager_creat_dataTask_queue;
}

static dispatch_queue_t url_session_manager_processing_queue() {
    static dispatch_queue_t fn_url_session_manager_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fn_url_session_manager_processing_queue = dispatch_queue_create("fn_url_session_manager_processing_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return fn_url_session_manager_processing_queue;
}

static dispatch_group_t url_session_manager_completion_group() {
    static dispatch_group_t fn_url_session_manager_completion_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fn_url_session_manager_completion_group = dispatch_group_create();
    });
    
    return fn_url_session_manager_completion_group;
}

@interface FNURLSessionManager ()

@property (nonatomic, strong)NSMutableData *mutableData;

@end

@implementation FNURLSessionManager

- (instancetype)init {
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    self.sessionConfiguration = configuration;
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.operationQueue];
    
    self.lock = [NSLock new];
    self.lock.name = FNURLSessionManagerLockName;
    
    self.mutableData = [NSMutableData data];
    
    self.completionGroup = url_session_manager_completion_group();
    self.completionQueue = dispatch_get_main_queue();
    
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request withCompletionHandler:(CompletionHandler)completionHandler {
    __block NSURLSessionDataTask *dataTask = nil;
    self.completionHandler = completionHandler;
    dispatch_sync(url_session_manager_creat_dataTask_queue(), ^{
        dataTask = [self.session dataTaskWithRequest:request];
    });
    return dataTask;
}

#pragma mark - URLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
}

#pragma mark - URLSessionDelegate

#pragma mark - URLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    [self.mutableData appendData:data];
    [data enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        [self.mutableData appendBytes:bytes length:byteRange.length];
    }];
}

#pragma mark - URLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    __block id responceData = nil;
    __block NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSData *data = nil;
    if (self.mutableData) {
        data = [self.mutableData copy];
        self.mutableData = nil;
    }
    if (data) {
        userInfo[FNURLTaskCompletedResponceData] = data;
    }
    
    if (error) {
        dispatch_group_async(self.completionGroup, self.completionQueue, ^{
            self.completionHandler(task.response, responceData, error);
        });
    } else {
        dispatch_group_async(self.completionGroup, self.completionQueue, ^{
            self.completionHandler(task.response, data, nil);
        });
    }
    
}

- (NSError *)creatErrorWithString:(NSString *)errorString {
    return [NSError errorWithDomain:@"fn_error_domain" code:9999 userInfo:@{NSLocalizedDescriptionKey : errorString}];
}
































@end
