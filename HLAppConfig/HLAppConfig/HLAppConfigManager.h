//
//  HLAppConfigManager.h
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import <Foundation/Foundation.h>

//static NSString * const HLAppConfigDidReloadNotification = @"com.hanly.app.config.reload";

@class HLAppConfigModel;
@class HLAppConfigSettings;

@interface HLAppConfigManager : NSObject

@property (readonly, strong) HLAppConfigModel *configModel;
@property (readonly, strong, getter=getDefaultConfigModel) HLAppConfigModel *defaultConfigModel;

- (instancetype)initWithSettings:(HLAppConfigSettings *)settings;

- (void)loadLocalConfigs;

- (void)loadRemoteConfigs;

- (void)updateConfigsWithValue:(NSString *)value forKey:(NSString *)key;

@end
