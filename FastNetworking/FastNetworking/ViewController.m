//
//  ViewController.m
//  FastNetworking
//
//  Created by ZhangSC on 15/12/14.
//  Copyright © 2015年 FastNetworking. All rights reserved.
//

#import "ViewController.h"
#import "FNHttpSessionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary *parameters = @{@"p" : @1,
                                 @"size" : @5,
                                 @"tab" : @"改装"
                                 };
    [[FNHttpSessionManager manager] sendURL:@"http://bbs.che-by.com/api/section" withMethod:nil parameters:nil completionHandler:^(NSURLResponse *responce, id responceObject, NSError *error) {
        NSData *data = responceObject;
        NSError *err = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        NSLog(@"%@", dic);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
