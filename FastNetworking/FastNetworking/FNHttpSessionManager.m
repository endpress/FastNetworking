//
//  FNHttpSessionManager.m
//  FastNetworking
//
//  Created by ZhangSC on 15/12/14.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import "FNHttpSessionManager.h"

@implementation FNHttpSessionManager

+ (instancetype)manager {
    return [[[self class] alloc] initWithSessionConfiguration:nil];
}

- (void)sendURL:(NSString *)URLString
     withMethod:(NSString *)method
     parameters:(NSDictionary *)parameters completionHandler:(CompletionHandler)completionHandler
{
    self.completionHandler = completionHandler;
    NSMutableURLRequest *request = [self requestWithURL:URLString method:method parameters:parameters];
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request withCompletionHandler:completionHandler];
    [task resume];
}

- (NSMutableURLRequest *)requestWithURL:(NSString *)URLString method:(NSString *)method parameters:(NSDictionary *)parameters {
    if (!URLString.length) {
        NSError *error = [self creatErrorWithString:@"URL为空"];
        self.completionHandler(nil, nil, error);
        self.completionHandler = nil;
        return nil;
    }
    NSURL *url = [NSURL URLWithString:URLString];
    if (!url) {
        NSError *error = [self creatErrorWithString:@"URL不合法"];
        self.completionHandler(nil, nil, error);
        self.completionHandler = nil;
        return nil;
    }
    if (!method.length) {
        method = @"GET";
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if ([method isEqualToString:@"GET"]) {
        NSString *httpBody = [self getParametersStringWith:parameters];
        if (httpBody) {
            URLString = [URLString stringByAppendingString:@"?"];
            URLString = [URLString stringByAppendingString:httpBody];
        }
        request.URL = [NSURL URLWithString:URLString];
        [request setHTTPMethod:@"GET"];
        
    } else {
        NSString *httpBody = [self getParametersStringWith:parameters];
        if (httpBody) {
            NSData *httpBodyData = [httpBody dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:httpBodyData];
            [request setHTTPMethod:@"POST"];
        } else {
            NSError *error = [self creatErrorWithString:@"POST请求体为空"];
            self.completionHandler(nil, nil, error);
            self.completionHandler = nil;
            return nil;
        }
    }
    NSLog(@"发送网络请求 \n URL:%@ \n Method:%@", request.URL.absoluteString, request.HTTPMethod);
    return request;
}

#pragma mark -   对参数编码
- (NSString *)UrlEncodedString:(NSString *)sourceText
{
//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sourceText ,NULL ,CFSTR("!*'();@&=+$,/?%#[]") ,kCFStringEncodingUTF8));
    NSString *result = [sourceText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return result;
}

- (NSString *)getParametersStringWith:(NSDictionary *)parameters {
    if (!parameters.count) {
        return @"";
    }
    NSString *parametersString = [NSString string];
    for (NSString *key in parameters) {
        NSString *value = [NSString stringWithFormat:@"%@", [parameters valueForKey:key]];
        parametersString = [parametersString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", [self UrlEncodedString:key], [self UrlEncodedString:value]]];
    }
    parametersString = [parametersString substringToIndex:parametersString.length - 1];
    return parametersString;
}

@end
