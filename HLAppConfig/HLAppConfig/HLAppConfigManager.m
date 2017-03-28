//
//  HLAppConfigManager.m
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import "HLAppConfigManager.h"
#import "HLAppConfigModel.h"
#import "HLAppConfigFileStore.h"

@interface HLAppConfigManager ()

@property (nonatomic, strong) NSURL *baseURL;
//@property (nonatomic, copy) NSString *localFile;

@property (atomic, strong) HLAppConfigModel *configModel;
@property (nonatomic, strong) HLAppConfigFileStore *store;

@end

@implementation HLAppConfigManager

+ (instancetype)sharedManager {
    static HLAppConfigManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSString *)urlString {
    return [self initWithBaseURL:urlString localFile:nil];
}

- (instancetype)initWithBaseURL:(NSString *)urlString localFile:(NSString *)file
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:urlString];
        if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
            url = [url URLByAppendingPathComponent:@""];
        }
        
        self.baseURL = url;
        //        self.localFile = file;
        
        self.store = [[HLAppConfigFileStore alloc] initWithLocalFilename:file];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRemoteConfigs) name:HLAppConfigDidReloadNotification object:nil];
    }
    
    return self;
}

- (void)loadLocalConfigs {
    NSDictionary *configs = [self.store readConfigs];
    NSLog(@"Local Configs: %@", configs);
    self.configModel =  [[HLAppConfigModel alloc] initWithDictionary:configs];
}

- (void)loadRemoteConfigs {
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.baseURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
#ifdef DEBUG
//    [request addValue:@"1146000447602" forHTTPHeaderField:@"u"];
#endif
    
     __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        NSDictionary *configs = nil;
        if (error) {
            NSLog(@"Http request error: %@", error.localizedDescription);
        } else {
            NSLog(@"Http request complete");
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode != 200) {
                NSLog(@"Http response failure statusCode: %@", @(httpResponse.statusCode));
            } else {
                NSError *error = nil;
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (error) {
                    NSLog(@"Parsing JSON error: %@", error);
                } else {
//                    NSLog(@"Reponse JSON Object: %@", jsonObject);
                    
                    NSInteger code = jsonObject[@"code"] ? ((NSString *)jsonObject[@"code"]).integerValue : -1;
                    if (code == 0) {//Success
                        configs = jsonObject[@"result"];
                    } else {
                        NSLog(@"Server error [ code: %@, message: %@ ]", jsonObject[@"code"], jsonObject[@"message"]);
                    }
                }
            }
        }
        NSLog(@"Remote Configs: %@", configs);
        if (configs && configs.count > 0) {
            strongSelf.configModel =  [[HLAppConfigModel alloc] initWithDictionary:configs];
            
#ifdef DEBUG
            [strongSelf.store writeConfigs:configs isPrettyPrint:YES];
#else
            [strongSelf.store writeConfigs:configs isPrettyPrint:NO];
#endif
        }
        
//        dispatch_semaphore_signal(semaphore);
    }];
    [sessionDataTask resume];
    
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

/*
- (void)updateConfigs {
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
 */

@end
