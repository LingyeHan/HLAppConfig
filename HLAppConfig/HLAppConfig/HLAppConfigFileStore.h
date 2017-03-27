//
//  HLAppConfigFileStore.h
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/24.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLAppConfigStore.h"

@interface HLAppConfigFileStore : NSObject <HLAppConfigStore>

- (instancetype)initWithLocalFilename:(NSString *)filename;

@end
