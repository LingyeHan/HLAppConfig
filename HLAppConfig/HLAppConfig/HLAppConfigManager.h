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

@interface HLAppConfigManager : NSObject

@property (atomic, readonly, strong) HLAppConfigModel *configModel;

- (instancetype)initWithBaseURL:(NSString *)urlString localFile:(NSString *)file;

- (void)loadLocalConfigs;

- (void)loadRemoteConfigs;

@end
