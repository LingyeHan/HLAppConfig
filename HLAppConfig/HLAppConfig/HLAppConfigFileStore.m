//
//  HLAppConfigFileStore.m
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/24.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import "HLAppConfigFileStore.h"

static NSString *const HLAppConfigFileStoreDefaultFilename = @"HLAppConfig.json";

@interface HLAppConfigFileStore ()

@property (nonatomic, copy) NSString *downloadPath;
@property (nonatomic, copy) NSString *localFilename;

@end

@implementation HLAppConfigFileStore

- (instancetype)init {
    return [self initWithLocalFilename:nil];
}

- (instancetype)initWithLocalFilename:(NSString *)filename {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [paths objectAtIndex:0];
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"iPhone simulator document directory: %@", documentDir);
#endif
        self.downloadPath = [documentDir stringByAppendingPathComponent:HLAppConfigFileStoreDefaultFilename];
        self.localFilename = filename ?: HLAppConfigFileStoreDefaultFilename;
    }
    return self;
}

- (void)writeConfigs:(id)configs isPrettyPrint:(BOOL)prettyPrint {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configs options:(prettyPrint ? NSJSONWritingPrettyPrinted : 0) error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [jsonStr writeToFile:self.downloadPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
}

- (NSDictionary *)readConfigs {
    NSDictionary *configs = [self readConfigsFromDownloadedFile:self.downloadPath];
    if (!configs) {
        configs = [self readDefaultConfigs];
    }
    return configs;
}

- (NSDictionary *)readDefaultConfigs {
     return [self readConfigsFromLocalFile:self.localFilename];
}

- (NSDictionary *)readConfigsFromDownloadedFile:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
}

- (NSDictionary *)readConfigsFromLocalFile:(NSString *)file {
    NSString *path = [[NSBundle mainBundle] pathForResource:file.stringByDeletingPathExtension ofType:file.pathExtension];
    
    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    
    return jsonDict;
}

@end

//        NSData *jsonData = [jsonObject[@"result"] dataUsingEncoding:NSUTF8StringEncoding];
//        [jsonData writeToFile:self.downloadFile atomically:YES];
//        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:jsonObject[@"configs"]];
//        [archivedData writeToFile:self.downloadFile atomically:YES];

//        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
//        NSURL *pathUrl = [NSURL fileURLWithPath:path];
//        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL URLWithString:self.localFile] error:nil];
