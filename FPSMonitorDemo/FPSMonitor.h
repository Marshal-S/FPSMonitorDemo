//
//  FPSMonitor.h
//  FPSMonitorDemo
//
//  Created by Marshal on 2021/7/12.
//  监听帧率的工具

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPSMonitor : NSObject

@property (nonatomic, copy) void (^onUpdateBlock)(NSInteger fpsCount);

+ (instancetype)sharedInstance;

- (void)startMonitor;

- (void)stopMonitor;

@end

//不需要的话，下面的UI可以删除
@interface FPSLabel : UILabel

//调用下面方法则创建并自动开启监听，默认位置在右上角
+ (instancetype)loadFPSLabel;

- (void)startMonitor;
- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
