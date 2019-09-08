//
//  IGRunloopManager.m
//  IGame
//
//  Created by junshao on 2019/9/8.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "IGRunloopManager.h"
#import "MJCallStack.h"

@interface IGRunloopManager(){
    CFRunLoopObserverRef _observer;
    dispatch_semaphore_t _semaphore;
    CFRunLoopActivity _activity;
}

@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, assign) NSInteger countTime;

@end

@implementation IGRunloopManager

+(IGRunloopManager *)sharedInstance{
    static dispatch_once_t token;
    static IGRunloopManager *sharedInstance;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)registerObserver{
    //设置observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    
    //创建observer对象
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    
    //将新建的observer加入到当前的runloop
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    _semaphore = dispatch_semaphore_create(0);
    __weak __typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf){
            return;
        }
        
        while(YES){
            
            if(strongSelf.isCancel){
                return;
            }
            long dsw = dispatch_semaphore_wait(self->_semaphore, dispatch_time(DISPATCH_TIME_NOW, strongSelf.limitMillisecond * NSEC_PER_MSEC));
            if(dsw != 0){
                if(self->_activity == kCFRunLoopBeforeSources || self->_activity == kCFRunLoopAfterWaiting){
                    if(++strongSelf.countTime < strongSelf.standstillCount){
                        NSLog(@"%ld", strongSelf.countTime);
                        continue;
                    }
                    
                    [strongSelf logStack];
                    [strongSelf printLogStack];
                    
                    NSString *backtrace = [MJCallStack mj_backtraceOfMainThread];
                    NSLog(@"+++%@",backtrace);
                    
                    if(strongSelf.callbackWhenStandStill){
                        strongSelf.callbackWhenStandStill();
                    }
                }
            }
            strongSelf.countTime = 0;
        }
    });
}

-(void)logStack{
//    void *callstack[128];
//    int frames = backtrace(callstack, 128);
//    char **strs = backtrace_symbols(callstack, frames);
//    int i;
//
}

-(void)printLogStack{
    
}

static void  runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    IGRunloopManager *instance = [IGRunloopManager sharedInstance];
    instance->_activity = activity;
    
    dispatch_semaphore_t semaphore = instance->_semaphore;
    dispatch_semaphore_signal(semaphore);
}

@end
