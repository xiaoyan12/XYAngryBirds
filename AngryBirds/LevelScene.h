//
//  LevelScene.h
//  AngryBirds
//
//  Created by Yang QianFeng on 11/07/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelScene : CCLayer {
    int successLevel; // 当前成功的通关数 1-14
}
+ (id) scene;

@end
