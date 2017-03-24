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
    
    NSString *url = @"http://localhost:8083/v1/app/config/fetch?v=1.0.0";
    NSString *localFile = @"HLAppConfig.json";
    [HLAppConfig startWithURL:url localFile:localFile];
    
    NSLog(@"得到配置：%@", HLConfigString(@"app_ui.theme.colors.text", @"not found"));
    NSLog(@"得到配置：%@", HLConfigString(@"all_text_content.sodis_prepaid_tips", @"not found"));
    NSLog(@"得到配置：%@", HLConfigString(@"fuck", @"not found"));
    NSLog(@"得到配置：%@", HLConfigString(@"fuckfuck", @"not found"));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

//    [NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.2.254/php/phonelogin?yourname=%@&yourpas=%@&btn=login",yourname,yourpass]];
}


@end
