//
//  JsonParser.m
//  MyAngryBirds
//
//  Created by Yang QianFeng on 11/06/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "JsonParser.h"

#import "SBJson.h"

@implementation SpriteModel

@synthesize tag, x, y, angle;

@end

@implementation JsonParser

+ (id) getAllSprite:(NSString *)file {
    NSString *levelContent = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    // 读取文件file里面的所有内容
    NSArray *spriteArray = [[[levelContent JSONValue] objectForKey:@"sprites"] objectForKey:@"sprite"];
    // json解析
    // SpriteModel精灵的数据模型对象
    NSMutableArray *a = [NSMutableArray array];
    for (NSDictionary *dict in spriteArray) {
        SpriteModel *sm = [[SpriteModel alloc] init];
        sm.tag = [[dict objectForKey:@"tag"] intValue];
        sm.x = [[dict objectForKey:@"x"] floatValue];
        sm.y = [[dict objectForKey:@"y"] floatValue];
        sm.angle = [[dict objectForKey:@"angle"] floatValue];
        
        [a addObject:sm];
        [sm release];
    }
    // 从数据文件中读取的所有的精灵对象
    return a;
}
@end
