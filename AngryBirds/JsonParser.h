//
//  JsonParser.h
//  MyAngryBirds
//
//  Created by Yang QianFeng on 11/06/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpriteModel : NSObject {
    int tag;
    float x;
    float y;
    float angle;
}
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float angle;

@end

@interface JsonParser : NSObject

+ (id) getAllSprite:(NSString *)file;

@end
