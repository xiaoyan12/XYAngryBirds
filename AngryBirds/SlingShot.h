//
//  SlingShot.h
//  AngryBirds
//
//  Created by yang on 21/3/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "CCSprite.h"

@interface SlingShot : CCSprite {
    CGPoint _startPoint1;
    CGPoint _startPoint2;
    
    CGPoint _endPoint;
}
@property (nonatomic, assign) CGPoint startPoint1;
@property (nonatomic, assign) CGPoint startPoint2;
@property (nonatomic, assign) CGPoint endPoint;


@end
