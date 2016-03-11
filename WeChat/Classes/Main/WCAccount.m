//
//  WCAccount.m
//  WeChat
//
//  Created by 卢良潇 on 16/1/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

#import "WCAccount.h"

@implementation WCAccount


+(instancetype)shareAccount
{
    return [[self alloc]init];

}


#pragma mark - 分配内存创建对象
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    NSLog(@"%s",__func__);
    
    static WCAccount *account;
 
    //为了线程安全 三个进程同时使用这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (account == nil) {
            account = [super allocWithZone:zone];
            
            
            //从沙盒获取上次的用户信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            account.loginUser = [defaults objectForKey:kUserKey];
            account.loginPwd = [defaults objectForKey:kpwdKey];
            account.login = [defaults objectForKey:kloginKey];
            
        }
    
    
    });
    return account;
}


-(void)saveToSandBox
{
//保存user  pwd login
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.loginUser forKey:kUserKey];
    [defaults setObject:self.loginPwd forKey:kpwdKey];
    [defaults setBool:self.login forKey:kloginKey];
    [defaults synchronize];

}
-(NSString *)domain
{
    return domain;
}

-(NSString *)host{
    return host;

}

-(int *)hostPort
{
    return hostPort;
}


@end
