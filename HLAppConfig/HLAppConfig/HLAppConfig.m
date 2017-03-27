//
//  HLAppConfig.m
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import "HLAppConfig.h"
#import "HLAppConfigModel.h"
#import "HLAppConfigManager.h"

static HLAppConfigModel *configModel = nil;

@interface HLAppConfig ()


@end

@implementation HLAppConfig

+ (void)startWithURL:(NSString *)url localFile:(NSString *)localFile {
    NSCParameterAssert(url != nil);
    HLAppConfigManager *appConfigManager = [[HLAppConfigManager alloc] initWithBaseURL:url localFile:localFile];
    [appConfigManager loadConfigs];
    configModel = appConfigManager.configModel;
    NSLog(@"AppConfigModel: %@", configModel);
}

@end

id HLConfigObject(NSString *key, id defaultValue) {
    return [configModel valueObjectForKey:key] ?: defaultValue;
}

NSDictionary *HLConfigDictionary(NSString *key, NSDictionary *defaultValue) {
    return [configModel dictionaryForKey:key] ?: defaultValue;
}

NSArray *HLConfigArray(NSString *key, NSArray *defaultValue) {
    return [configModel arrayForKey:key] ?: defaultValue;
}

NSURL *HLConfigURL(NSString *key, NSURL *defaultValue) {
    return [configModel URLForKey:key] ?: defaultValue;
}

NSString *HLConfigString(NSString *key, NSString *defaultValue) {
    return [configModel stringForKey:key] ?: defaultValue;
}

NSInteger HLConfigInteger(NSString *key, NSInteger defaultValue) {
    return [configModel integerForKey:key] ?: defaultValue;
}

float HLConfigFloat(NSString *key, float defaultValue) {
    return [configModel floatForKey:key] ?: defaultValue;
}

double HLConfigDouble(NSString *key, double defaultValue) {
    return [configModel doubleForKey:key] ?: defaultValue;
}

BOOL HLConfigBool(NSString *key, BOOL defaultValue) {
    return [configModel boolForKey:key] ?: defaultValue;
}
