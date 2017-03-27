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

+ (void)startWithURL:(NSString *)url localFile:(NSString *)localFile {
    NSCParameterAssert(url != nil);
    appConfigManager = [[HLAppConfigManager alloc] initWithBaseURL:url localFile:localFile];
}

@end

id HLConfigObject(NSString *key, id defaultValue) {
    return [appConfigManager.configModel valueObjectForKey:key] ?: defaultValue;
}

NSDictionary *HLConfigDictionary(NSString *key, NSDictionary *defaultValue) {
    return [appConfigManager.configModel dictionaryForKey:key] ?: defaultValue;
}

NSArray *HLConfigArray(NSString *key, NSArray *defaultValue) {
    return [appConfigManager.configModel arrayForKey:key] ?: defaultValue;
}

NSURL *HLConfigURL(NSString *key, NSURL *defaultValue) {
    return [appConfigManager.configModel URLForKey:key] ?: defaultValue;
}

NSString *HLConfigString(NSString *key, NSString *defaultValue) {
    return [appConfigManager.configModel stringForKey:key] ?: defaultValue;
}

NSInteger HLConfigInteger(NSString *key, NSInteger defaultValue) {
    return [appConfigManager.configModel integerForKey:key] ?: defaultValue;
}

float HLConfigFloat(NSString *key, float defaultValue) {
    return [appConfigManager.configModel floatForKey:key] ?: defaultValue;
}

double HLConfigDouble(NSString *key, double defaultValue) {
    return [appConfigManager.configModel doubleForKey:key] ?: defaultValue;
}

BOOL HLConfigBool(NSString *key, BOOL defaultValue) {
    return [appConfigManager.configModel boolForKey:key] ?: defaultValue;
}
