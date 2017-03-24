//
//  HLAppConfig.h
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const HLNetworkingTaskDidResumeNotification;

FOUNDATION_EXPORT NSString *HLConfigString(NSString *key, NSString *defaultValue);

@interface HLAppConfig : NSObject

+ (void)startWithURL:(NSString *)url localFile:(NSString *)localFile;

@end
