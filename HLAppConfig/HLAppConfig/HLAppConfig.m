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

static HLAppConfigManager *appConfigManager = nil;

@interface HLAppConfig ()

@end

@implementation HLAppConfig

// TODO 后期添加Config参数类：开发调试日志开关、加载策略等
+ (void)startWithSettings:(HLAppConfigSettings *)settings {
    NSCParameterAssert(settings != nil);
    appConfigManager = [[HLAppConfigManager alloc] initWithSettings:settings];
    [appConfigManager loadLocalConfigs];
}

+ (BOOL)syncReload {
//    [[NSNotificationCenter defaultCenter] postNotificationName:HLAppConfigDidReloadNotification object:nil];
    return [appConfigManager loadRemoteConfigsSync:YES];
}

+ (void)asyncReload {
    [appConfigManager loadRemoteConfigsSync:NO];
}

+ (void)updateWithValue:(NSString *)value forKey:(NSString *)key {
    [appConfigManager updateConfigsWithValue:value forKey:key];
}

@end

///

NSString *HLCString(NSString *key) {
    return HLConfigString(key, @"");
}

NSInteger HLCInteger(NSString *key) {
    return HLConfigInteger(key, 0);
}

float HLCFloat(NSString *key) {
    return HLConfigFloat(key, 0.0f);
}

double HLCDouble(NSString *key) {
    return HLConfigDouble(key, 0.0f);
}

BOOL HLCBool(NSString *key) {
    return HLConfigBool(key, false);
}

///

id HLConfigObject(NSString *key, id defaultValue) {
    return [appConfigManager.configModel valueObjectForKey:key] ?: ([appConfigManager.defaultConfigModel valueObjectForKey:key] ?: defaultValue);
}

NSDictionary *HLConfigDictionary(NSString *key, NSDictionary *defaultValue) {
    return [appConfigManager.configModel dictionaryForKey:key] ?: ([appConfigManager.defaultConfigModel dictionaryForKey:key] ?: defaultValue);
}

NSArray *HLConfigArray(NSString *key, NSArray *defaultValue) {
    return [appConfigManager.configModel arrayForKey:key] ?: ([appConfigManager.defaultConfigModel arrayForKey:key] ?: defaultValue);
}

NSURL *HLConfigURL(NSString *key, NSURL *defaultValue) {
    return [appConfigManager.configModel URLForKey:key] ?: ([appConfigManager.defaultConfigModel URLForKey:key] ?: defaultValue);
}

NSString *HLConfigString(NSString *key, NSString *defaultValue) {
    return [appConfigManager.configModel stringForKey:key] ?: ([appConfigManager.defaultConfigModel stringForKey:key] ?: defaultValue);
}

NSInteger HLConfigInteger(NSString *key, NSInteger defaultValue) {
    return [appConfigManager.configModel integerForKey:key] ?: ([appConfigManager.defaultConfigModel integerForKey:key] ?: defaultValue);
}

float HLConfigFloat(NSString *key, float defaultValue) {
    return [appConfigManager.configModel floatForKey:key] ?: ([appConfigManager.defaultConfigModel floatForKey:key] ?: defaultValue);
}

double HLConfigDouble(NSString *key, double defaultValue) {
    return [appConfigManager.configModel doubleForKey:key] ?: ([appConfigManager.defaultConfigModel doubleForKey:key] ?: defaultValue);
}

BOOL HLConfigBool(NSString *key, BOOL defaultValue) {
    return [appConfigManager.configModel boolForKey:key] ?: ([appConfigManager.defaultConfigModel boolForKey:key] ?: defaultValue);
}
