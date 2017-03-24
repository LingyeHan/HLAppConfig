//
//  HLAppConfigManager.m
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import "HLAppConfigManager.h"
#import "HLAppConfigModel.h"

@interface HLAppConfigManager ()

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, copy) NSString *localFile;
@property (nonatomic, copy) NSString *downloadFile;
@property (nonatomic, strong) HLAppConfigModel *configModel;

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
        //        if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        //            url = [url URLByAppendingPathComponent:@""];
        //        }
        
        self.baseURL = url;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [paths objectAtIndex:0];
        self.downloadFile = [docDirectory stringByAppendingPathComponent:@"HLAppConfig.json"];
        self.localFile = file;
        
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"Local File Path: %@", self.downloadFile);
#endif
        
        //        self.configEntries = [[NSMutableDictionary alloc] init];
        //        [self login];
        //         [self _loadLocalConfigs];
//        [self loadDownloadedConfigs];
        [self loadConfigs];
    }
    
    return self;
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

// TODO 加同步机制
- (void)loadConfigs {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:self.baseURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [request addValue:@"1146000447602" forHTTPHeaderField:@"u"];
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *configs = nil;
        if (error) {
            NSLog(@"Error: %@", error);
            
            configs = [self loadDownloadedConfigs];
            if (!configs) {
                configs = [self loadLocalConfigs];
            }
        } else {
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"从服务器获取到数据: %@", jsonObject);
        
        NSInteger code = jsonObject[@"code"] ? ((NSString *)jsonObject[@"code"]).integerValue : -1;
        if (code != 0) {
            NSLog(@"Json Data format 不合法: %@", jsonObject);
        } else {
            configs = jsonObject[@"result"];
            // async write to file
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, DISPATCH_QUEUE_SERIAL), ^{
                // prettyPrint ? NSJSONWritingPrettyPrinted : 0
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configs options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [jsonStr writeToFile:self.downloadFile atomically:YES];
            });
        }
        }
        NSLog(@"Load Configs: %@", configs);
        self.configModel =  [[HLAppConfigModel alloc] initWithDictionary:configs];
        

        
        dispatch_semaphore_signal(semaphore);

        //        NSData *jsonData = [jsonObject[@"result"] dataUsingEncoding:NSUTF8StringEncoding];
        //        [jsonData writeToFile:self.downloadFile atomically:YES];
        //        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:jsonObject[@"configs"]];
        //        [archivedData writeToFile:self.downloadFile atomically:YES];
        
        //        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        //        NSURL *pathUrl = [NSURL fileURLWithPath:path];
        //        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL URLWithString:self.localFile] error:nil];
    }];
    
    [sessionDataTask resume];
    NSLog(@"sessionDataTask resume 开始。。。。。");
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}




@end
