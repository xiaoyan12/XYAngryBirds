//
//  AppDelegate.m
//  AngryBirds
//
//  Created by Yang QianFeng on 16/06/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//
// 把AppDelegate.m -- >
// AppDelegate.mm 原因是
// 可以混合OC/C/C++东西
#import "AppDelegate.h"
#import "RootViewController.h"
#import "cocos2d.h"
// 只要是 cocosd游戏 都要加cocos2d.h
#import "LoadingScene.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (![CCDirector setDirectorType:kCCDirectorTypeDisplayLink]) {
        // 设置导演类型为kCCDirectorTypeDisplayLink
        // 如果设置成功就返回YES 否则返回NO
        [CCDirector setDirectorType:kCCDirectorTypeDefault];
        // 如果返回NO 就用kCCDirectorTypeDefault
    }
    
    CCDirector *director = [CCDirector sharedDirector];
    // 取得当前导演 只有一个 单利模式
    // 创建一个舞台
    EAGLView *glView = [EAGLView viewWithFrame:[self.window bounds] pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
    // 创建一个舞台UIView OpenGL ES
    [director setOpenGLView:glView];
    // 让director和glView关联
    [director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
    // 设置游戏的方向为左横屏
    [director setAnimationInterval:1.0f/60.0f];
    // 设置游戏的刷新率 每秒60
    [director setDisplayFPS:YES];
    // 显示当前的刷新率
    
    RootViewController *rvc = [[RootViewController alloc] init];
    [rvc setView:glView];
    [self.window setRootViewController:rvc];
    [rvc release];
    // 把rvc作为window的根视图
        
    [self.window makeKeyAndVisible];
    // 要显示第一个剧场
    CCScene *sc = [LoadingScene scene];
    [[CCDirector sharedDirector] runWithScene:sc];
    // 让导演运行sc这个剧场.
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[CCDirector sharedDirector] pause];
    // 暂停游戏
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[CCDirector sharedDirector] stopAnimation];
    // 停止刷新 停止动画
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[CCDirector sharedDirector] startAnimation];
    // 开始动画
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[CCDirector sharedDirector] resume];
    // 恢复运行
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    CCDirector *director = [CCDirector sharedDirector];
    [[director openGLView] removeFromSuperview];
    [self.window release];
    [director end];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (void) applicationSignificantTimeChange:(UIApplication *)application {
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
