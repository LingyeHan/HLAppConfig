//
//  ViewController.m
//  Example
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import "ViewController.h"
#import <HLAppConfig/HLAppConfig.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self login];
    sleep(3);
    
    [HLAppConfig reload];
//    [HLAppConfig updateWithValue:@"23,12,56" forKey:@"user_update_for_ios"];
    
    sleep(3);
    
    NSLog(@"得到配置：%@", HLConfigString(@"app_ui2.theme.colors.text", nil));
    NSLog(@"得到配置：%@", HLConfigString(@"app_ui.theme.colors.text", nil));
    NSLog(@"得到配置：%@", HLConfigString(@"all_text_content.sodis_prepaid_tips", @"not found"));
    NSLog(@"得到配置：%@", HLConfigString(@"app_ui.theme.colors.background", @"not found"));
    NSLog(@"得到配置：%@", HLConfigString(@"app_ui2.theme.colors.text", @"not found"));
    NSLog(@"得到配置：%d", HLConfigInteger(@"all_text_content.red_list_max_year", nil));
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:HLAppConfigDidReloadNotification object:nil];

}

- (void)login {
    NSString *username = @"15027877580";
    NSString *password = @"123456";
    
    NSString *body = @"{\"phone\":\"15027877580\",\"passwd\":\"123456\"}";
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://test.zuifuli.io/api/customer/v1/account/login"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Login Error: %@", error);
        } else {
            NSLog(@"Login Success: %@", response);
        }
    }];
    
    [sessionDataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

//    [NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.2.254/php/phonelogin?yourname=%@&yourpas=%@&btn=login",yourname,yourpass]];
}


@end
