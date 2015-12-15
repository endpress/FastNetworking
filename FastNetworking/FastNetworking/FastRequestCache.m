//
//  FastRequestCache.m
//  FastNetworking
//
//  Created by ZhangSC on 15/12/15.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import "FastRequestCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface FastRequestCache ()

@property (nonatomic, copy)NSString *diskCachePath;

@end

@implementation FastRequestCache

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    return [self initWithNameSpace:@"FastNetworking"];
}

- (instancetype)initWithNameSpace:(NSString *)nameSpace {
    self = [super init];
    self.diskCachePath = [self getDiskPathWithNameSpace:nameSpace];
    _operateQueue = dispatch_queue_create("FastNetworking_Cache_Queue_Key", DISPATCH_QUEUE_SERIAL);
    self.fileManager = [NSFileManager new];
    return self;
}

- (NSString *)getDiskPathWithNameSpace:(NSString *)nameSpace {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    
    return [path stringByAppendingPathComponent:nameSpace];
}

- (void)storeRequestData:(NSData *)data ForKey:(NSString *)key {
    if (!key.length) {
        return;
    }
    if (!data) {
        return;
    }
    dispatch_async(self.operateQueue, ^{
        NSString *path = [self pathforKey:key];
//        NSLog(@"store path = %@ and store key = %@", path, key);
        if (![_fileManager fileExistsAtPath:path]) {
            [_fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSError *error = nil;
        [_fileManager removeItemAtPath:path error:&error];
        if (error) {
            return ;
        }
        [_fileManager createFileAtPath:path contents:data attributes:nil];
    });
}

- (NSData *)getRequestCacheDataForKey:(NSString *)key {
    if (!key.length) {
        return nil;
    }
    NSData *data = nil;
    NSString *path = [self pathforKey:key];
//    NSLog(@"get path = %@ and get key = %@", path, key);
    if ([_fileManager fileExistsAtPath:path]) {
        data = [_fileManager contentsAtPath:path];
    }
    return data;
}

- (NSString *)pathforKey:(NSString *)key {
    if (!key.length) {
        return @"";
    }
    key = [self cachedFileNameForKey:key];
    return [self.diskCachePath stringByAppendingPathComponent:key];
}

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
}


















@end
