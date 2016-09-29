//
//  StartScene.m
//  AngryBirds
//
//  Created by Yang QianFeng on 23/06/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "StartScene.h"
#import "ParticleManager.h"
#import "LevelScene.h"

@implementation StartScene

+ (id) scene {
    CCScene *sc = [CCScene node];
    StartScene *ss = [StartScene node];
    [sc addChild:ss];
    return sc;
}
+ (id) node {
    return [[[[self class] alloc] init] autorelease];
}
- (id) init {
    self = [super init];
    if (self) {
        // 创建菜单
        CGSize s = [[CCDirector sharedDirector] winSize];
        // 得到屏幕宽高
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"startbg.png"];
        [bgSprite setPosition:ccp(s.width/2.0f, s.height/2.0f)];
        // 以图片startbg.png创建背景精灵
        // 然后设置精灵的位置为屏幕的中心点
        [self addChild:bgSprite];
        
        CCSprite *angryBirdSprite = [CCSprite spriteWithFile:@"angrybird.png"];
        [angryBirdSprite setPosition:ccp(240.0f, 250.0f)];
        [self addChild:angryBirdSprite];
        
        // 加一个菜单
        CCSprite *beginSprite = [CCSprite spriteWithFile:@"start.png"];
        CCMenuItemSprite *beginMenuItem = [CCMenuItemSprite itemFromNormalSprite:beginSprite selectedSprite:nil target:self selector:@selector(beginGame:)];
        // 创建了一个菜单项，里面放了一个精灵beginSprite
        // 正常状态是这个精灵，选中这里设置为nil
        // 当点击了就调用self里面的beginGame:方法
        CCMenu *menu = [CCMenu menuWithItems:beginMenuItem, nil];
        [menu setPosition:ccp(240.0f, 130.0f)];
        [self addChild:menu];
        
        // 加一个定时器
        [self schedule:@selector(tick:) interval:1.0f];
        // 每隔1s来执行tick方法
        
        // 加雪花的粒子效果
        CCParticleSystem *snow = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeSnow];
        // 取得雪花的粒子效果对象
        [self addChild:snow];
        // 把雪花粒子效果加入到self上
    }
    return self;
}
- (void) createOneBird {
    // 创建一个小鸟
    CCSprite *bird = [[CCSprite alloc] initWithFile:@"bird1.png"];
    [bird setScale:(arc4random()%5)/10.0f];
    // 给小鸟一个缩放比例 
    [bird setPosition:ccp(50.0f+arc4random()%50, 70.0f)];
    // arc4random()产生一个随机数
    // 给bird一个动作 可以跳跃的动作
    CGPoint endPoint = ccp(360.0f+arc4random()%50, 70.0f);
    // 设置一个终点
    CGFloat height = arc4random()%100+50.0f;
    CGFloat time = 2.0f;
    id actionJump = [CCJumpTo actionWithDuration:time position:endPoint height:height jumps:1];
    // 创建一个动作，动作执行时间是time 2s 最终位置是endPoint, 最大高度height
    id actionFinish = [CCCallFuncN actionWithTarget:self selector:@selector(actionFinish:)];
    // 这是一个完成动作的函数
    CCSequence *allActions = [CCSequence actions:actionJump, actionFinish, nil];
    // 定义了一个顺序的动作 首先执行actionJump 然后执行actionFinish动作
    [bird runAction:allActions];
    // 让bird执行一个动作
    
    [self addChild:bird];
    [bird release];
}
- (void) actionFinish:(CCNode *)currentNode {
    // 加上小鸟撞到地板的粒子效果
    CCParticleSystem *explosition = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeBirdExplosion];
    // 得到爆破效果的粒子对象
    [explosition setPosition:[currentNode position]];
    // 把currentNode和粒子效果对象位置保持一样
    // 就是让粒子效果在那里发生
    [self addChild:explosition];
    
    // 只要这个方法被调用，就说明动作已经执行完成
    // currentNode其实就是bird
    // 从屏幕上删除这个currentNode;
    //[self removeChild:currentNode cleanup:YES];
    [currentNode removeFromParentAndCleanup:YES];
}
- (void) tick:(double) dt {
    [self createOneBird];
}
- (void) beginGame:(id)arg {
    NSLog(@"开始游戏");
    // 启动LevelScene剧场
    
    CCScene *level = [LevelScene scene];
    // 1. 竖向动画
//    CCTransitionScene *trans = [[CCTransitionSplitCols alloc] initWithDuration:5.0f scene:level];
// 2. 横向剧场
//    CCTransitionScene *trans = [[CCTransitionSplitRows alloc] initWithDuration:5.0f scene:level];
    // 3. 雷达效果(2种)
//    CCTransitionScene *trans = [[CCTransitionRadialCCW alloc] initWithDuration:5.0f scene:level];
    // 4. 小格子动画
//    CCTransitionScene *trans = [[CCTransitionTurnOffTiles alloc] initWithDuration:5.0f scene:level];
    // 5. 左右滑动
//    CCTransitionScene *trans = [[CCTransitionSlideInL alloc] initWithDuration:5.0f scene:level];
    // 6. 翻转效果
//    CCTransitionScene *trans = [[CCTransitionFlipX alloc] initWithDuration:5.0f scene:level];

    // 7. 翻转效果
//    CCTransitionScene *trans = [[CCTransitionZoomFlipAngular alloc] initWithDuration:1.0f scene:level];

    CCTransitionScene *trans = [[CCTransitionSplitRows alloc] initWithDuration:1.0f scene:level];

    // 给一个时间5s 让他CCTransitionSplitCols动画到level剧场
    // trans也是一个剧场
    [[CCDirector sharedDirector] replaceScene:trans];
    // 导演切换到动画剧场 trans
    [trans release];
}

@end
