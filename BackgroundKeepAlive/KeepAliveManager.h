//
//  KeepAliveManager.h
//  BackgroundKeepAliveDemo
//
//  Created by Admin on 2023/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeepAliveManager : NSObject

+ (instancetype)sharedInstance;
-(void)setEnabled:(BOOL)enabled;
@end

NS_ASSUME_NONNULL_END
