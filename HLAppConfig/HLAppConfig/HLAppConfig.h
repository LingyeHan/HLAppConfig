//
//  HLAppConfig.h
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLAppConfigSettings.h"

FOUNDATION_EXPORT id HLConfigObject(NSString *key, id defaultValue);

FOUNDATION_EXPORT NSDictionary *HLConfigDictionary(NSString *key, NSDictionary *defaultValue);

FOUNDATION_EXPORT NSArray *HLConfigArray(NSString *key, NSArray *defaultValue);

FOUNDATION_EXPORT NSURL *HLConfigURL(NSString *key, NSURL *defaultValue);

FOUNDATION_EXPORT NSString *HLConfigString(NSString *key, NSString *defaultValue);

FOUNDATION_EXPORT NSInteger HLConfigInteger(NSString *key, NSInteger defaultValue);

FOUNDATION_EXPORT float HLConfigFloat(NSString *key, float defaultValue);

FOUNDATION_EXPORT double HLConfigDouble(NSString *key, double defaultValue);

FOUNDATION_EXPORT BOOL HLConfigBool(NSString *key, BOOL defaultValue);

@interface HLAppConfig : NSObject

+ (void)startWithSettings:(HLAppConfigSettings *)settings;

+ (void)reload;

+ (void)updateWithValue:(NSString *)value forKey:(NSString *)key;

@end
