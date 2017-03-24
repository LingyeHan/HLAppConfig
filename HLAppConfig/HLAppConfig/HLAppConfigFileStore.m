//
//  HLAppConfigFileStore.m
//  HLAppConfig
//
//  Created by 韩灵叶 on 2017/3/24.
//  Copyright © 2017年 HanLingye. All rights reserved.
//

#import "HLAppConfigFileStore.h"

@implementation HLAppConfigFileStore

- (void)writeToFile:(NSString *)path {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, DISPATCH_QUEUE_SERIAL), ^{
        // prettyPrint ? NSJSONWritingPrettyPrinted : 0
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configs options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [jsonStr file writeToFile:path atomically:YES];
    });
}

- (NSDictionary *)readF {
    NSData *data = [NSData dataWithContentsOfFile:self.downloadFile];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
}

- (NSDictionary *)loadLocalConfigs {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.localFile.stringByDeletingPathExtension ofType:self.localFile.pathExtension];
    
    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    
    return jsonDict;
}

@end
