//
//  LoadingScene.m
//  AngryBirds
//
//  Created by Yang QianFeng on 17/06/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "LoadingScene.h"
#import "StartScene.h"

@implementation LoadingScene
+ (id) scene {
    CCScene *sc = [CCScene node];
    // 创建了一个空的剧场
    LoadingScene *ls = [LoadingScene node];
    // 创建了一个我们自己的节目
    [sc addChild:ls];
    // 把我们的节目加到通用的剧场上 CCScene
    return sc;
}
+ (id) node {
    return [[[[self class] alloc] init] autorelease];
}
- (id) init {
    self = [super init];
    if (self) {
        // 标准init方法
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // 通过导演类CCDirector来获取屏幕的宽高
        CCSprite *sp = [CCSprite spriteWithFile:@"loading.png"];
        // 创建了一个精灵对象，这个对象就是一张图片
        [sp setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        // ccp = CGPointMake
        // 设置精灵的中心坐标
        [self addChild:sp];
        // 把精灵加入到self中 self就是节目
        
        loadingTitle = [[CCLabelBMFont alloc] initWithString:@"Loading" fntFile:@"arial16.fnt"];
        // 把@"Loading"字符串使用字体 arial16.fnt加载到
        // CCLabelBMFont中
        [loadingTitle setAnchorPoint:ccp(0.0f, 0.0f)];
        // 设置loadingTitle锚点为(0.0f, 0.0f);
        [loadingTitle setPosition:ccp(winSize.width-80.0f, 10.0f)];
        // 设置position
        [self addChild:loadingTitle];
        // 让Loading字符串 每隔1s前进一个.
        [self schedule:@selector(loadTick:) interval:2.0f];
        // 每隔2.0f来调用 [self loadTick:];方法
    }
    return self;
}
- (void) loadTick:(double)dt {
    // 每隔2.0fs会来调用
    static int count;
    count++;
    NSString *s = [NSString stringWithFormat:
            @"%@%@", [loadingTitle string], @"."];
    // [loadingTitle string]原来字符串
    // 在原来字符串后面追加  .
    [loadingTitle setString:s];
    // 把loadingTitle上设置显示字符串 s
    if (count >= 1) {
        [self unscheduleAllSelectors];
        // 取消所有的定时器
        // 加载下一个剧场
        CCScene *sc = [StartScene scene];
        [[CCDirector sharedDirector] replaceScene:sc];
        // 把当前剧场销毁，然后启动sc这个新的剧场
    }
}
- (void) dealloc {
    [loadingTitle release], loadingTitle = nil;
    [super dealloc];
}
@end
