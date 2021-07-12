//
//  FPSMonitor.m
//  FPSMonitorDemo
//
//  Created by Marshal on 2021/7/12.
//

#import "FPSMonitor.h"
#import <QuartzCore/QuartzCore.h>

@interface FPSMonitor ()
{
    CADisplayLink *_displayLink;
    CFTimeInterval _beginTime; //计算一轮帧率的开始时间
    NSInteger _count;
}

@end

@implementation FPSMonitor

+ (instancetype)sharedInstance {
    static FPSMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance->_beginTime = 0;
        instance->_count = 0;
    });
    return instance;
}

- (void)loopLink:(CADisplayLink *)link {
    if (_beginTime == 0) {
        _beginTime = link.timestamp;
        return;
    }
    _count++;
    //不够1s直接结束
    CFTimeInterval delta = link.timestamp - _beginTime;
    if (delta < 1) return;
    
    NSInteger fpsCount = _count / delta; //结果直接取整
    
    if (_onUpdateBlock) _onUpdateBlock(fpsCount);
    
    _beginTime = link.timestamp;
    _count = 0;
}

- (void)startMonitor {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(loopLink:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopMonitor {
    if (_displayLink) {
        [_displayLink invalidate];
        [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink = nil;
    }
}

- (void)dealloc {
    [self stopMonitor];
}

@end

@implementation FPSLabel

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 2, 40, 16)]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:12];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        __weak typeof(self) wself = self;
        [[FPSMonitor sharedInstance] setOnUpdateBlock:^(NSInteger fpsCount) {
            __strong typeof(self) sself = wself;
            if (fpsCount <= 20) {
                sself.textColor = [UIColor redColor];
            }else if (fpsCount <= 40) {
                sself.textColor = [UIColor yellowColor];
            }else {
                sself.textColor = [UIColor greenColor];
            }
            sself.text = [NSString stringWithFormat:@"%ld", fpsCount];
        }];
    }
    return self;
}

+ (instancetype)loadFPSLabel {
    FPSLabel *fpsLabel = [[FPSLabel alloc] init];
    [fpsLabel startMonitor];
    return fpsLabel;
}

- (void)startMonitor {
    [[FPSMonitor sharedInstance] startMonitor];
}

- (void)stopMonitor {
    [[FPSMonitor sharedInstance] stopMonitor];
}

- (void)dealloc {
    [[FPSMonitor sharedInstance] stopMonitor];
}

@end
