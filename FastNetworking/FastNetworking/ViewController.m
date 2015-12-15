//
//  ViewController.m
//  FastNetworking
//
//  Created by ZhangSC on 15/12/14.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import "ViewController.h"
#import "FNHttpSessionManager.h"
#import <mach/mach_time.h>

@interface ViewController ()

@end

@implementation ViewController {
    uint64_t start;
    uint64_t end;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary *parameters = @{@"p" : @1,
                                 @"size" : @5,
                                 @"tab" : @"改装"
                                 };
    [[FNHttpSessionManager manager] sendGETRequestWithURLString:@"http://bbs.che-by.com/api/index" parameters:nil cacheHandler:^(NSURLResponse *responce, id responceObject, NSData *data, NSError *error) {
        NSError *err = nil;
        if (error) {
            NSLog(@"error === %@", error.localizedDescription);
        } else {
            start = mach_absolute_time();
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
            
        }
        
    } completionHandler:^(NSURLResponse *responce, id responceObject, NSError *error) {
        end = mach_absolute_time();
        mach_timebase_info_data_t timebase;
        mach_timebase_info(&timebase);
        
        NSLog(@"time fast %f", (end - start) * (double)timebase.numer / (double)timebase.denom * 1e-9);
        NSData *data = responceObject;
        NSError *err = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
//        NSLog(@"real dic == %@", dic);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
