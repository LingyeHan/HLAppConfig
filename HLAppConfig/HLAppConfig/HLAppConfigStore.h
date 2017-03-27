//
//  HLAppConfigStore.h
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HLAppConfigStore <NSObject>

- (void)writeConfigs:(id)configs isPrettyPrint:(BOOL)prettyPrint;

- (NSDictionary *)readConfigs;


@end
