//
//  Bird.h
//  AngryBirds
//
//  Created by yang on 10/3/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"

#import "SpriteBase.h"

@interface Bird : SpriteBase
{
    BOOL _isFly;
    BOOL _isReady;
}
@property (nonatomic, assign) BOOL isFly;
@property (nonatomic, assign) BOOL isReady;

-(void)setSpeedX:(float)x andY:(int)y andWorld:(b2World*)world;
-(void)hitAnimationX:(float)x andY:(float)y;


@end
