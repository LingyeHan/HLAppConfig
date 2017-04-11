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
#import "HLAppConfigSettings.h"

@interface HLAppConfigManager ()

@property (nonatomic, strong) HLAppConfigSettings *configSettings;

@property (atomic, strong) HLAppConfigModel *configModel;
@property (nonatomic, strong, getter=getDefaultConfigModel) HLAppConfigModel *defaultConfigModel;
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

- (instancetype)initWithSettings:(HLAppConfigSettings *)settings;
{
    self = [super init];
    if (self) {
        self.configSettings = settings;
        self.store = [[HLAppConfigFileStore alloc] initWithLocalFilename:settings.localFilename];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRemoteConfigs) name:HLAppConfigDidReloadNotification object:nil];
    }
    
    return self;
}


- (HLAppConfigModel *)getDefaultConfigModel {
    if (!_defaultConfigModel) {
        _defaultConfigModel = [[HLAppConfigModel alloc] initWithDictionary:[self.store readDefaultConfigs]];
    }
    return _defaultConfigModel;
}

- (void)loadLocalConfigs {
    NSDictionary *configs = [self.store readConfigs];
    NSLog(@"Local Configs: %@", configs);
    self.configModel =  [[HLAppConfigModel alloc] initWithDictionary:configs];
}

- (BOOL)loadRemoteConfigsSync:(BOOL)sync {
    dispatch_semaphore_t semaphore = NULL;
    if (sync) { semaphore = dispatch_semaphore_create(0); }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.configSettings.baseUrl, self.configSettings.fetchPath]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
#ifdef DEBUG
//    [request addValue:@"1146000447602" forHTTPHeaderField:@"u"];
#endif
//    [request addValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"GET"];
    
    NSLog(@"Storage Http Cookie: %@", [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    
    __block BOOL isSuccess = NO;
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
                        NSLog(@"Fetch remote configuration server error [ code: %@, message: %@ ]", jsonObject[@"code"], jsonObject[@"msg"]);
                    }
                }
            }
        }
        NSLog(@"Fetch Remote Configs: %@", configs);
        if (configs && configs.count > 0) {
            strongSelf.configModel =  [[HLAppConfigModel alloc] initWithDictionary:configs];
            isSuccess = YES;
#ifdef DEBUG
            [strongSelf.store writeConfigs:configs isPrettyPrint:YES];
#else
            [strongSelf.store writeConfigs:configs isPrettyPrint:NO];
#endif
        }
        
        if (semaphore) { dispatch_semaphore_signal(semaphore); };
    }];
    [sessionDataTask resume];
    
    if (semaphore) { dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); };
    return isSuccess;
}

- (void)updateConfigsWithValue:(NSString *)value forKey:(NSString *)key {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.configSettings.baseUrl, self.configSettings.updatePath]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [request addValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    bodyDict[@"version"] = self.configModel.version;
    bodyDict[@"ckey"] = key;
    bodyDict[@"value"] = value;
    
    NSError *error = nil;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:&error];
    [request setHTTPBody:bodyData];

    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

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
                    NSInteger code = jsonObject[@"code"] ? ((NSString *)jsonObject[@"code"]).integerValue : -1;
                    if (code == 0) {
                        NSLog(@"Update remote configuration successfully.");
                    } else {
                        NSLog(@"Update remote configuration server error [ code: %@, message: %@ ]", jsonObject[@"code"], jsonObject[@"msg"]);
                    }
                }
            }
        }
    }];
    [sessionDataTask resume];
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
