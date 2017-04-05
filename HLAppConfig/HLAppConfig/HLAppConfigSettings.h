//
//  HLAppConfigSettings.h
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/4/5.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLAppConfigSettings : NSObject

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, copy) NSString *fetchPath;
@property (nonatomic, copy) NSString *updatePath;
@property (nonatomic, copy) NSString *localFilename;

@end
