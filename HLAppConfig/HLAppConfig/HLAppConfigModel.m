//
//  HLAppConfigModel.m
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/23.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import "HLAppConfigModel.h"

static NSString *const HLAppConfigModelMetaKey = @"meta";
static NSString *const HLAppConfigModelConfigKey = @"configs";

@interface HLAppConfigModel ()

@property (nonatomic, copy) NSDictionary *meta;

@end

@implementation HLAppConfigModel

- (instancetype)init
{
    return [self initWithDictionary:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.meta = [dictionary[HLAppConfigModelMetaKey] copy];
            self.configs = dictionary;
        } else {
            self = nil;
        }
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    HLAppConfigModel *otherConfigModel = object;
    
    return [self.configs isEqualToDictionary:otherConfigModel.configs];
}

- (NSUInteger)hash
{
    return [self.configs hash];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p>: %@", NSStringFromClass(self.class), self, self.configs];
}

#pragma mark - Private Method

- (void)setConfigs:(NSDictionary *)dictionary {
    NSDictionary *configs = nil;
    if ([dictionary[HLAppConfigModelConfigKey] isKindOfClass:[NSArray class]]) {
        NSMutableDictionary *dict  = [NSMutableDictionary dictionary];
        [dictionary[HLAppConfigModelConfigKey] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dict addEntriesFromDictionary:obj];
        }];

        configs = [NSDictionary dictionaryWithDictionary:dict];
    } else {
        configs = [dictionary[HLAppConfigModelConfigKey] copy];
    }
    
    _configs = configs;
}

//- (NSMutableDictionary *)transformWithDictionary:(NSDictionary *)dictionary {
//    NSMutableDictionary *dict  = [NSMutableDictionary dictionary];
//    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
//        NSDictionary *jsonObject = [self JSONObjectWithJSONString:value];
//        [dict addEntriesFromDictionary:[NSDictionary dictionaryWithObject:jsonObject forKey:key]];
//    }];
//    return dict;
//}

//- (id)JSONObjectWithJSONString:(NSString *)jsonString {
//    NSString *j = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    if (![NSJSONSerialization isValidJSONObject:]) {
//        return jsonString;
//    }
//    
//    id jsonObject = nil;
//    NSData *jsonData = nil;
//    if ([jsonString isKindOfClass:[NSString class]]) {
//        jsonData = [(NSString *)jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    }
//    if (jsonData) {
//        jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
//    }
//    return jsonObject;
//}

- (id)valueObjectForKey:(NSString *)key class:(Class)class
{
    id object = [self valueObjectForKey:key];
    
    return ([object isKindOfClass:class]) ? object : nil;
}

- (id)valueObjectForKey:(NSString *)key selector:(SEL)selector
{
    id object = [self valueObjectForKey:key];
    
    return ([object respondsToSelector:selector]) ? object : nil;
}

#pragma mark - Public Method

- (NSString *)getVersion
{
    return self.meta ? self.meta[@"version"] : nil;
}

- (id)valueObjectForKey:(NSString *)key
{
    NSParameterAssert(key);
    
    if (!self.configs) {
        return nil;
    }
    
    if (![key containsString:@"."]) {
        return self.configs[key];
    }
    
    // key 支持 "." 语法处理
    __block id configs = self.configs;
    NSArray *keys = [key componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![configs[key] isKindOfClass:[NSDictionary class]]) {
            *stop = YES;
        }
        configs = configs[key];
    }];
    
    return configs;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    return [self valueObjectForKey:key class:[NSDictionary class]];
}

- (NSArray *)arrayForKey:(NSString *)key
{
    return [self valueObjectForKey:key class:[NSArray class]];
}

- (NSURL *)URLForKey:(NSString *)key
{
    NSURL *url = [self valueObjectForKey:key class:[NSURL class]];
    if (!url) {
        NSString *stringValue = [self stringForKey:key];
        url = [NSURL URLWithString:[stringValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return url;
}

- (NSString *)stringForKey:(NSString *)key
{
    return [self valueObjectForKey:key class:[NSString class]];
}

- (NSInteger)integerForKey:(NSString *)key
{
    id numberObject = [self valueObjectForKey:key selector:@selector(intValue)];
    
    return [numberObject intValue];
}

- (float)floatForKey:(NSString *)key
{
    id floatObject = [self valueObjectForKey:key selector:@selector(floatValue)];
    
    return [floatObject floatValue];
}

- (double)doubleForKey:(NSString *)key
{
    id doubleObject = [self valueObjectForKey:key selector:@selector(doubleValue)];
    
    return [doubleObject doubleValue];
}

- (BOOL)boolForKey:(NSString *)key
{
    id boolObject = [self valueObjectForKey:key selector:@selector(boolValue)];
    
    return [boolObject boolValue];
}

@end
