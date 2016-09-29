//
//  ParticleManager.h
//  AngryBirds
//
//  Created by Yang QianFeng on 24/06/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// 我们要定义2中粒子效果
typedef enum {
    ParticleTypeSnow,  // 雪花的粒子效果
    ParticleTypeBirdExplosion, // 爆破的粒子效果
    ParticleTypeMax
} ParticleTypes;

@interface ParticleManager : NSObject
+ (id) sharedParticleManager; 
// 取得单例对象
- (CCParticleSystem *) particleWithType:(ParticleTypes)type;
// 取得指定type的粒子对象

@end
