//
//  GameUtils.h
//  AngryBirds
//
//  Created by Yang QianFeng on 11/07/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameUtils : NSObject

+ (int) readLevelFromFile;
+ (void) writeLevelToFile:(int)level;

@end
