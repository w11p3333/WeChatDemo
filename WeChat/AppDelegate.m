//
//  AppDelegate.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/12.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "AppDelegate.h"
#import "DDTTYLogger.h"
#import "DDLog.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置xmpp日志
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
    
    
    
    //来到主界面
    
    
    
    if ([WCAccount shareAccount].isLogin) {
        id mainVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
        self.window.rootViewController = mainVc;
        
        //自动登录
        [[WCXMPPTool sharedWCXMPPTool] xmpplogin:nil];
    }
//
//    [self setupStream];
//    [self connectToHost];
    // Override point for customization after application launch.
   return YES;
}



@end
