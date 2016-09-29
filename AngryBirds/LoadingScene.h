//
//  LoadingScene.h
//  AngryBirds
//
//  Created by Yang QianFeng on 17/06/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
// CCLayer是所有场景的基类
@interface LoadingScene : CCLayer
{
    CCLabelBMFont *loadingTitle;
    // 定义一个展示字符串的一个对象
}
// 提供给外部一个 scene 
+ (id) scene;
@end
