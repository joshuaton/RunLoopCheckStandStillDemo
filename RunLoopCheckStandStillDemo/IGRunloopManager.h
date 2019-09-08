//
//  IGRunloopManager.h
//  IGame
//
//  Created by junshao on 2019/9/8.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGRunloopManager : NSObject

//超过多少毫秒为一次卡顿，400ms
@property (nonatomic, assign) int limitMillisecond;

//多少次卡顿记为一次有效
@property (nonatomic, assign) int standstillCount;

//发生有效卡顿的回调
@property (nonatomic, copy) void (^callbackWhenStandStill)(void);

+(IGRunloopManager *)sharedInstance;

-(void)registerObserver;

@end
