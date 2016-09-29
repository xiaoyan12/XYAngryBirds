//
//  GameScene.m
//  AngryBirds
//
//  Created by Yang QianFeng on 28/07/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "GameScene.h"
#import "SlingShot.h"
#define SLINGSHOT_POS CGPointMake(85, 125)

@implementation GameScene

+ (id) sceneWithLevel:(int)level {
    CCScene *cs = [CCScene node];
    // 创建了一个节目ccscene
    GameScene *gs = [GameScene nodeWithLevel:level];
    [cs addChild:gs];
    return  cs;
}
+ (id) nodeWithLevel:(int)level {
    return [[[[self class] alloc] initWithLevel:level] autorelease];
}

- (id) initWithLevel:(int)level {
    self = [super init];
    if (self) {
        currentLevel = level;
        // 要创建精灵
        // 创建北京
        CCSprite *bgSprite = [CCSprite spriteWithFile:@"bg.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        bgSprite.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:bgSprite];
        
        NSString *scoreStr = [NSString stringWithFormat:@"分数:%d", score];
        scoreLable = [[CCLabelTTF alloc] initWithString:scoreStr dimensions:CGSizeMake(300, 300) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:30];
        scoreLable.position = ccp(450, 170);
        [self addChild:scoreLable];
        
        CCSprite *leftShot = [CCSprite spriteWithFile:@"leftshot.png"];
        leftShot.position = ccp(85, 110);
        [self addChild:leftShot];
        
        CCSprite *rightShot = [CCSprite spriteWithFile:@"rightshot.png"];
        rightShot.position = ccp(85, 110);
        [self addChild:rightShot];
        
        slingShot = [[SlingShot alloc] init];
        slingShot.startPoint1 = ccp(82, 130);
        slingShot.startPoint2 = ccp(92, 128);
        slingShot.endPoint = SLINGSHOT_POS;
        slingShot.contentSize = CGSizeMake(480, 320);
        slingShot.position = ccp(240, 160);
        [self addChild:slingShot];
        
        // 把标准的touch打开
        self.isTouchEnabled = YES;
        // 注册cocos2d特有的事件方法
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

        [self createWorld];
        [self createLevel];
    }
    return self;
}
- (void) createWorld {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    b2Vec2 gravity;
    gravity.Set(0.0f, -5.0f);
    
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
    
    contactListener = new MyContactListener(world, self);
    world->SetContactListener(contactListener);
    // 给world设置碰撞监听对象
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0);
    
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    b2PolygonShape groundBox;
    // bottom
    groundBox.SetAsEdge(b2Vec2(0,(float)87/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,(float)87/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    [self schedule:@selector(tick:)];
}

-(void) tick: (ccTime) dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	world->Step(dt, velocityIterations, positionIterations);
    
//	birdCount = 0;
//    pigCount = 0;
	for (b2Body *b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			SpriteBase *oneSprite = (SpriteBase *)b->GetUserData();
            
            switch (oneSprite.tag) {
                case BIRD_ID:
//                    birdCount++;
                    break;
                case PIG_ID:
//                    pigCount++;
                    break;
            }
            
			oneSprite.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			oneSprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            
            //如果小鸟停止运动删除小鸟
            if (oneSprite.tag == BIRD_ID) {
                if (!b->IsAwake()) {
                    world->DestroyBody(b);
                    [oneSprite destory];
                }
            }
//
            if (oneSprite.HP <= 0 || oneSprite.position.x > 480 || oneSprite.position.y < 84) {
                world->DestroyBody(b);
                [oneSprite destory];
            }
		}
	}
    
//    if (pigCount == 0 && !gameFinish) {
//        gameFinish = true;
//        isWin = true;
//        [self calculatePoint];
//    }else if(birdCount == 0 && [birds count] == 0 && !gameFinish){
//        gameFinish = true;
//        isWin = false;
//        [self calculatePoint];
//    }
    
}



- (void) createLevel {
    // 1, 2
    NSString *s = [NSString stringWithFormat:@"%d", currentLevel];
    NSString *path = [[NSBundle mainBundle] pathForResource:s ofType:@"data"];
    NSLog(@"path is %@", path);
    NSArray *spriteArray = [JsonParser getAllSprite:path];
    for (SpriteModel *sm in spriteArray) {
        switch (sm.tag) {
            case PIG_ID:
            {
                CCSprite *pig = [[Pig alloc] initWithX:sm.x andY:sm.y andWorld:world  andLayer:self];
                [self addChild:pig];
                [pig release];
                break;
            }
            case ICE_ID:
            {
                CCSprite *ice = [[Ice alloc] initWithX:sm.x andY:sm.y andWorld:world  andLayer:self];
                [self addChild:ice];
                [ice release];
                break;
            }
            default:
                break;
        }
    }
    
    birds = [[NSMutableArray alloc] init];
    Bird *bird = [[Bird alloc] initWithX:160 andY:93 andWorld:world andLayer:self];
    Bird *bird2 = [[Bird alloc] initWithX:140 andY:93 andWorld:world andLayer:self];
    Bird *bird3 = [[Bird alloc] initWithX:120 andY:93 andWorld:world andLayer:self];

    [self addChild:bird];
    [self addChild:bird2];
    [self addChild:bird3];
    [birds addObject:bird];
    [birds addObject:bird2];
    [birds addObject:bird3];

    [bird release];
    [bird2 release];
    [bird3 release];
    
    [self jump];
}

- (void) jump {
    if (birds.count > 0 && !gameFinish) {
        currentBird = [birds objectAtIndex:0];
        CCJumpTo *action = [[CCJumpTo alloc] initWithDuration:1 position:SLINGSHOT_POS height:50 jumps:1];
        CCCallBlockN *jumpFinish = [[CCCallBlockN alloc] initWithBlock:^(CCNode *node) {
            gameStart = YES;
            currentBird.isReady = YES;
        }];
        // 动作序列 执行完action后在执行jumpFinish动作
        CCSequence *allActions = [CCSequence actions:action, jumpFinish, nil];
        [action release];
        [jumpFinish release];
        [currentBird runAction:allActions];
    }
}

#define TOUCH_UNKNOW 0
#define TOUCH_SHOTBIRD 1
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // 判断时候触摸点落在currBird区域内
    touchStatus = TOUCH_UNKNOW;
    CGPoint location = [self convertTouchToNodeSpace:touch];
    if (currentBird == nil) {
        return NO;
    }
    CGRect birdRect = currentBird.boundingBox;
    // 取得bird的区域
    if (CGRectContainsPoint(birdRect, location)) {
        // 判断触摸点是否落在bird区域
        touchStatus = TOUCH_SHOTBIRD;
        return YES;
    }
    return NO;
}
// 触摸过程中
- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touchStatus == TOUCH_SHOTBIRD) {
        // 说明选中小鸟 可以拉动弹工
        CGPoint location = [self convertTouchToNodeSpace:touch];
        // 取得当前手指的点
        slingShot.endPoint = location;
        currentBird.position = location;
        // 把小鸟和弹工的位置都设置为location;
    }
}
// from p1--p2
- (CGFloat) getRatioFromPoint:(CGPoint )p1 toPoint:(CGPoint) p2 {
    return (p2.y-p1.y)/(p2.x-p1.x);
}
- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // 手放开 1. 让bird飞出去 2. 让弹工复位
    if (touchStatus == TOUCH_SHOTBIRD) {
        CGPoint location = [self convertTouchToNodeSpace:touch];
        slingShot.endPoint = SLINGSHOT_POS;
        // 从拉动 location ---> SLINGSHOT_POS
        CGFloat r = [self getRatioFromPoint:location toPoint:SLINGSHOT_POS];
        CGFloat endx = 300;
        CGFloat endy = endx*r +location.y;
        CGPoint destPoint = ccp(endx, endy);
        
        float x =(85.0f-location.x)*50.0f/70.0f;
        float y =(125.0f-location.y)*50.0f/70.0f;
        [currentBird setSpeedX:x andY:y andWorld:world];

        [birds removeObject:currentBird];
        currentBird = nil;
        [self performSelector:@selector(jump) withObject:nil afterDelay:2.0f];
        // 2.0f之后把下一个小鸟
    }
}

- (void) dealloc {
    [birds release];
    [scoreLable release];
    [super dealloc];
}
- (void) sprite:(SpriteBase *)sprite withScore:(int)score {
    
}


@end
