//
//  HLAppConfigModel.h
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLAppConfigModel : NSObject

@property (nonatomic, copy, getter=getVersion) NSString *version;
@property (nonatomic, readonly, copy) NSDictionary *configs;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (id)valueObjectForKey:(NSString *)key;

- (NSDictionary *)dictionaryForKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key;

- (NSURL *)URLForKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key;

- (float)floatForKey:(NSString *)key;

- (double)doubleForKey:(NSString *)key;

- (BOOL)boolForKey:(NSString *)key;

@end
