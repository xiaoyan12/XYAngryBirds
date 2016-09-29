//
//  SpriteBase.h
//  MyAngryBirds
//
//  Created by Yang QianFeng on 10/06/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#define PTM_RATIO 32
//  小鸟
#define BIRD_ID 1
// 小猪
#define PIG_ID 2
#define ICE_ID 3
@protocol SpriteDelegate;
@interface SpriteBase : CCSprite
{
    float HP; // 生命值
    int fullHP;
    NSString *imageUrl;
    CCLayer <SpriteDelegate> *myLayer;
    b2World *myWorld;
    b2Body *myBody;
}
@property (nonatomic, assign) float HP;
-(id) initWithX:(float)x andY:(float)y andWorld:(b2World *)world andLayer:(CCLayer <SpriteDelegate> *)layer;
-(void) destory;

@end

@protocol SpriteDelegate <NSObject>

- (void) sprite:(SpriteBase *)sprite withScore:(int)score;

@end
