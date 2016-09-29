//
//  LevelScene.m
//  AngryBirds
//
//  Created by Yang QianFeng on 11/07/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "LevelScene.h"
#import "GameUtils.h"
#import "StartScene.h"
#import "GameScene.h"

@implementation LevelScene

+ (id) scene {
    CCScene *sc = [CCScene node];
    LevelScene *ls = [[LevelScene alloc] init];
    [sc addChild:ls];
    [ls release];
    return sc;
}
- (id) init {
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // 放一个背景图片精灵
        CCSprite *sp = [CCSprite spriteWithFile:@"selectlevel.png"];
        sp.position = ccp(winSize.width/2.0f, winSize.height/2.0f);
        [self addChild:sp];
        // 放一个放回键的精灵
        CCSprite *backsp = [CCSprite spriteWithFile:@"backarrow.png"];
        backsp.position = ccp(40.0f, 40.0f);
        backsp.scale = 0.5f;
        backsp.tag = 100;
        [self addChild:backsp];
        
        [self setIsTouchEnabled:YES];
        // 把self的触摸开关打开
        // 让self可以接受触摸事件
        
        // 加上14关
        successLevel = [GameUtils readLevelFromFile];;
        NSString *imgPath = nil;
        for (int i = 0; i < 14; i++) {
            if (i < successLevel) {
                // 已经通关的
                imgPath = @"level.png";
                NSString *str = [NSString stringWithFormat:
                                 @"%d", i+1];
                CCLabelTTF *numLabel = [CCLabelTTF labelWithString:str dimensions:CGSizeMake(60.0f, 60.0f) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:30.0f];
                float x = 60+i%7*60;
                float y = 320-75-i/7*80;
                numLabel.position = ccp(x, y);
                [self addChild:numLabel z:2];
            } else {
                // 加锁的关卡
                imgPath = @"clock.png";
            }
            CCSprite *levelSprite = [CCSprite spriteWithFile:imgPath];
            // 设置图片精灵
            levelSprite.tag = i+1; // i+1为了避免tag为0
            float x = 60+i%7*60;
            float y = 320-60-i/7*80;
            levelSprite.position = ccp(x, y);
            levelSprite.scale = 0.6f;
            [self addChild:levelSprite z:1];
        }
        
    }
    return self;
}

// 触摸结束时候
// touches 就是触摸点的集合
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // 1. 拿到ui触摸点
    UITouch *oneTouch = [touches anyObject];
    UIView *touchView = [oneTouch view];
    // 取得当前触摸的一个uiview
    // 这里的touchview其实就是 glview
    CGPoint location = [oneTouch locationInView:touchView];
    // 2. 转成world opengl point
    CGPoint worldGlPoint = [[CCDirector sharedDirector] convertToGL:location];
    // 把ui 坐标转化成world世界坐标
    CGPoint nodePoint = [self convertToNodeSpace:worldGlPoint];
    // 把世界坐标转化为node坐标 self
    // self.children.count self上所有的一层孩子
    for (int i = 0; i < self.children.count; i++) {
        CCSprite *oneSprite = [self.children objectAtIndex:i];
        // 取得self屏幕上第i个精灵
        if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && oneSprite.tag == 100) {
            // 如果nodePoint包含在oneSprite中
            // 并且tag为100
            CCScene *sc = [StartScene scene];
            CCTransitionScene *trans = [[CCTransitionSplitRows alloc] initWithDuration:1.0f scene:sc];
            [[CCDirector sharedDirector] replaceScene:trans];
            [trans release];
        } else if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && (oneSprite.tag < successLevel+1) && oneSprite.tag >0) {
            NSLog(@"选中了第 %d 关", oneSprite.tag);
            CCScene *sc = [GameScene sceneWithLevel:oneSprite.tag];
            [[CCDirector sharedDirector] replaceScene:sc];
        }
    }
}

@end
